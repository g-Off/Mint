import Foundation

public struct GitURL: CustomStringConvertible {
	private let urlString: String
	public let path: String
	public let branch: String?
	
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
		func cleanPath(from string: String) -> String {
			return URL(string: string)?.deletingPathExtension().path ?? ""
		}
		
		if string.hasPrefix("https://") {
			let (repo, branch) = string.split(around: "@")
			self.urlString = repo
			self.path = cleanPath(from: repo)
			self.branch = branch
		} else if let colonIndex = string.index(of: ":") {
			let afterColonIndex = string.index(after: colonIndex)
			if let atIndex = string[colonIndex...].index(of: "@") {
				self.urlString = String(string[..<atIndex])
				self.path = cleanPath(from: String(string[afterColonIndex..<atIndex]))
				self.branch = String(string[string.index(after: atIndex)...])
			} else {
				self.urlString = string
				self.path = String(string[afterColonIndex...])
				self.branch = nil
			}
		} else {
			let (path, branch) = string.split(around: "@")
			var components = URLComponents()
			components.scheme = "https"
			components.host = "github.com"
			components.path = path
			self.urlString = components.string!
			self.path = cleanPath(from: path)
			self.branch = branch
		}
	}
	
	public var description: String {
		return urlString
	}
}
