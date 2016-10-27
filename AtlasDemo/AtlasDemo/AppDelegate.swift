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

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        guard let
            navigationController = window?.rootViewController as? UINavigationController,
            catalogViewController = navigationController.viewControllers.first as? CatalogViewController else { return }

        catalogViewController.loadHomepageArticles()
    }

}
