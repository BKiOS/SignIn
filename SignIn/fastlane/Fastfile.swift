// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	func betaLane() {
	desc("Push a new beta build to TestFlight")
		incrementBuildNumber(xcodeproj: "SignIn.xcodeproj")
        package(config: Staging())
//		uploadToTestflight(username: "boobalan.m@spantechnologyservices.com")
	}

    func package(config: Configuration) {
        var export: [String: Any]? = [
            "signingStyle": "manual",
            "provisioningProfiles": [appIdentifier: "DemoTest"]
        ]
        let version = getVersionNumber(target: "SignIn")
        let date = Date.getCurrentDate()
        
        let buildName = "SignIn_\(version)_\(date).ipa"
        buildApp(workspace: "SignIn.xcworkspace", scheme: "SignIn", clean: true, outputName: "\(buildName)", exportMethod: "development", exportOptions: .userDefined(export))
    }
    
    
}

protocol Configuration {
    /// file name of the certificate
    var certificate: String { get }

    /// file name of the provisioning profile
    var provisioningProfile: String { get }

    /// configuration name in xcode project
    var buildConfiguration: String { get }

    /// the app id for this configuration
    var appIdentifier: String { get }

    /// export methods, such as "ad-doc" or "appstore"
    var exportMethod: String { get }
}

struct Staging: Configuration {
    var certificate = "development"
    var provisioningProfile = "DemoTest"
    var buildConfiguration = "Staging"
    var appIdentifier = "com.newProject.SignIn"
    var exportMethod = "development"
}

struct Production: Configuration {
    var certificate = "ios_distribution"
    var provisioningProfile = "DemoTest"
    var buildConfiguration = "Production"
    var appIdentifier = "com.newProject.SignIn"
    var exportMethod = "ad-hoc"
}
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMddyyyy"

        return dateFormatter.string(from: Date())

    }
}
