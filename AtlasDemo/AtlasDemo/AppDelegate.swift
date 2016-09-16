//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

var AppSetupInstance = AppSetup() // swiftlint:disable:this variable_name
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()
        AppSetupInstance.setupApp()
        return true
    }

}
