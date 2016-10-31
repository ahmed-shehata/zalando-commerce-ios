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
            AppSetup.configure { result in
                guard let catalogViewController = CatalogViewController.instance else { return }
                switch result {
                case .success: catalogViewController.loadHomepageArticles()
                case .failure(let error): catalogViewController.displayError(error)
                }
            }
        } else if let catalogViewController = CatalogViewController.instance where catalogViewController.articles.isEmpty {
            catalogViewController.loadHomepageArticles()
        }
    }

}
