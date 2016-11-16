//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK
import AtlasUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        if !AppSetup.isConfigured {
            AppSetup.configure { configured in
                guard configured else {
                    print("App Configuration failed")
                    return
                }
                CatalogViewController.instance?.loadHomepageArticles()
            }
        } else if let catalogViewController = CatalogViewController.instance where catalogViewController.articles.isEmpty {
            catalogViewController.loadHomepageArticles()
        }
    }

}
