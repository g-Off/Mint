import Foundation
import Utility

class RunCommand: PackageCommand<PackageOptions> {

    init(mint: Mint, parser: ArgumentParser) {
        super.init(mint: mint, parser: parser, name: "run", description: "Installs and then runs a package")
    }
	
	override func execute<T: PackageOptions>(options: T) throws {
		try mint.run(options: options)
	}
}
