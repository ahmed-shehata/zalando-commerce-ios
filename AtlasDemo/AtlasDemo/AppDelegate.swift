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
        guard let
            navigationController = window?.rootViewController as? UINavigationController,
            catalogViewController = navigationController.viewControllers.first as? CatalogViewController
            where catalogViewController.articles.isEmpty else { return }

        AppSetup.configure { result in
            switch result {
            case .success: catalogViewController.loadHomepageArticles()
            case .failure(let error): catalogViewController.displayError(error)
            }
        }
    }

}
