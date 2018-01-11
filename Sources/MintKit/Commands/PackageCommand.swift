import Foundation
import Utility

public class PackageOptions {
	var buildFlags = BuildFlags()
	var package: GitURL = try! GitURL("")
	var version: String {
		return package.branch ?? ""
	}
	var verbose: Bool = false
	var global: Bool = false
	
	var command: String = ""
	var arguments: [String]?
	
	public required init() {}
}

extension GitURL: ArgumentKind {
	public init(argument: String) throws {
		do {
			self = try GitURL(argument)
		} catch {
			throw ArgumentConversionError.typeMismatch(value: argument, expectedType: GitURL.self)
		}
	}
	
	public static let completion: ShellCompletion = .none
}

class PackageCommand<T: PackageOptions> : MintCommand {
	
	let binder = ArgumentBinder<T>()

    override init(mint: Mint, parser: ArgumentParser, name: String, description: String) {
        super.init(mint: mint, parser: parser, name: name, description: description)

        let packageHelp = """
        The identifier for the Swift Package to use. It can be a shorthand for a github repo \"githubName/repo\", or a fully qualified .git path.
        An optional version can be specified by appending @version to the repo, otherwise the newest tag will be used (or master if no tags are found)
        """
		binder.bind(positional: subparser.add(positional: "package", kind: GitURL.self, optional: false, usage: packageHelp)) { (options, package) in
			options.package = package
			let command = ((package.path as NSString).deletingPathExtension as NSString).lastPathComponent
			options.command = command
		}
		binder.bindArray(positional: subparser.add(positional: "command", kind: [String].self, optional: true, strategy: .remaining, usage: "The command to run. This will default to the package name")) { (options, commands) in
			
			// backwards compatability for arguments surrounded in quotes
//			if let args = arguments,
//				args.count == 1,
//				let firstArg = args.first,
//				firstArg.contains(" ") {
//				arguments = firstArg.split(separator: " ").map(String.init)
//			}
			
			options.command = commands[0]
			options.arguments = Array(commands.dropFirst())
		}
		binder.bind(option: subparser.add(option: "--global", shortName: "-g", kind: Bool.self, usage: "Whether to install the executable globally. Defaults to false")) { (options, global) in
			options.global = global
		}
		binder.bind(option: subparser.add(option: "--verbose", kind: Bool.self, usage: "Show installation output")) { (options, verbose) in
			options.verbose = verbose
		}
		binder.bindArray(
			subparser.add(
				option: "-Xcc", kind: [String].self, strategy: .oneByOne,
				usage: "Pass flag through to all C compiler invocations"),
			subparser.add(
				option: "-Xswiftc", kind: [String].self, strategy: .oneByOne,
				usage: "Pass flag through to all Swift compiler invocations"),
			subparser.add(
				option: "-Xlinker", kind: [String].self, strategy: .oneByOne,
				usage: "Pass flag through to all linker invocations"),
			to: {
				$0.buildFlags.cCompilerFlags = $1
				$0.buildFlags.swiftCompilerFlags = $2
				$0.buildFlags.linkerFlags = $3
		})
    }

    override func execute(parsedArguments: ArgumentParser.Result) throws {
		var packageOptions = T()
		binder.fill(parsedArguments, into: &packageOptions)
		try execute(options: packageOptions)
    }
	
	func execute<T>(options: T) throws {
		// empty implementation
	}
}
