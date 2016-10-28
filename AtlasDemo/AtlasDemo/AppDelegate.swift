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
        if AppSetup.checkout == nil {
            AppSetup.configure { result in
                guard let catalogViewController = AppDelegate.catalogViewController else { return }
                switch result {
                case .success: catalogViewController.loadHomepageArticles()
                case .failure(let error): catalogViewController.displayError(error)
                }
            }
        } else if let catalogViewController = AppDelegate.catalogViewController where catalogViewController.articles.isEmpty {
            catalogViewController.loadHomepageArticles()
        }
    }

    static var catalogViewController: CatalogViewController? {
        guard let
            navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController,
            catalogViewController = navigationController.viewControllers.first as? CatalogViewController
            else { return nil }
        return catalogViewController
    }

}
