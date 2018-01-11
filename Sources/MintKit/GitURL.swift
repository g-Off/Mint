import Foundation

public struct GitURL: CustomStringConvertible {
	private enum RegexGroupName: String {
		case url
		case path
		case version
	}
	
	public let urlString: String
	public let path: String
	public let tag: String?
	
	/// Converts a string in various Git URL formats with an optional version specifier.
	/// The initialized object contains the actual URL, the path, as well as an optional tag specifier
	///
	/// Supports multiple types of URLs
	/// * HTTPS: https://github.com/Carthage/Carthage.git
	/// * SCP: [user@]host.xz:path/to/repo.git/ git@github.com:Carthage/Carthage.git
	/// * etc.
	///
	/// - Parameter string: String value to convert into a GitURL with optional version
	/// - Throws: Throws an MintError.invalidRepo if the string cannot be parsed correctly
	public init(_ string: String) throws {
		let pattern = "^(?<\(RegexGroupName.url.rawValue)>(?:git@[\\-\\w\\.]+:|(?:git|ssh|https):\\/\\/)?([\\-\\w\\.]+\\.[\\w]+/)?(?<\(RegexGroupName.path.rawValue)>.*?)(?:\\.git)?)(?:@(?<\(RegexGroupName.version.rawValue)>[\\w\\d\\.]+))?$"
		let regex = try NSRegularExpression(pattern: pattern, options: [])
		let nsString = NSString(string: string)
		var groupCaptures: [RegexGroupName: String] = [:]
		for result in regex.matches(in: string, options: [], range: NSMakeRange(0, nsString.length)) {
			[RegexGroupName.url, RegexGroupName.path, RegexGroupName.version].enumerated().forEach {
				let range: NSRange
				if #available(OSX 10.13, *) {
					range = result.range(withName: $0.element.rawValue)
				} else {
					range = result.range(at: $0.offset)
				}
				guard range.location != NSNotFound else { return }
				groupCaptures[$0.element] = nsString.substring(with: range)
			}
		}
		guard let url = groupCaptures[.url], let path = groupCaptures[.path] else {
			throw MintError.invalidRepo(string)
		}
		
		self.urlString = url
		self.path = path
		self.tag = groupCaptures[.version]
	}
	
	public var description: String {
		return urlString
	}
}
