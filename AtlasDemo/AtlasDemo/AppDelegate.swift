//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if !AppSetup.isConfigured {
            AppSetup.configure { configured in
                guard configured else {
                    print("App Configuration failed")
                    return
                }
                CatalogViewController.shared?.loadHomepageArticles()
            }
        } else if let catalogViewController = CatalogViewController.shared, catalogViewController.articles.isEmpty {
            catalogViewController.loadHomepageArticles()
        }
    }

}
