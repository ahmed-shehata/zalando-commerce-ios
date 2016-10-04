//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()
        AppSetup.configure()

        setupBugScreenshot()

        Lookback.setupWithAppToken("yxHNcPapi4XecJDit")
        Lookback.sharedLookback().shakeToRecord = false
        Lookback.sharedLookback().feedbackBubbleVisible = true

        return true
    }

}
