import Foundation
import Utility

class InstallCommand: InstallOrUpdateCommand {

    init(mint: Mint, parser: ArgumentParser) {
        super.init(
            mint: mint,
            parser: parser,
            name: "install",
            description: "Installs a package. If the version is already installed no action will be taken",
            update: false
        )
    }
}

class UpdateCommand: InstallOrUpdateCommand {

    init(mint: Mint, parser: ArgumentParser) {
        super.init(
            mint: mint,
            parser: parser,
            name: "update",
            description: "Updates a package even if it's already installed",
            update: true
        )
    }
}

class InstallOrUpdateCommand: PackageCommand<PackageOptions> {
    var update: Bool

    init(mint: Mint, parser: ArgumentParser, name: String, description: String, update: Bool) {
        self.update = update
        super.init(mint: mint, parser: parser, name: name, description: description)
    }
	
	override func execute<T: PackageOptions>(options: T) throws {
		try mint.install(options: options, update: update)
	}
}
