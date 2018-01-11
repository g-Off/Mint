import Foundation
import PathKit

/// Contains all the paths for packages
struct PackagePath {

    let path: Path
    let package: Package

    init(path: Path, package: Package) {
        self.path = path
        self.package = package
    }

    var gitPath: String { return "\(package.repo)" }

    var repoPath: String {
		return package.repo.path.replacingOccurrences(of: "/", with: "_")
//        return gitPath
//            .components(separatedBy: "://").last!
//            .replacingOccurrences(of: "/", with: "_")
//            .replacingOccurrences(of: ".git", with: "")
    }

    var packagePath: Path { return path + repoPath }
    var installPath: Path { return packagePath + "build" + package.version }
    var commandPath: Path { return installPath + package.name }
}
