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
        AppSetup.configure(loadHomepageArticles)

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        guard let catalogViewController = catalogViewController where catalogViewController.articles.isEmpty else { return }
        AppSetup.configure(loadHomepageArticles)
    }

    func loadHomepageArticles(result: AtlasResult<AtlasCheckout>) {
        guard let catalogViewController = catalogViewController else { return }

        switch result {
        case .success: catalogViewController.loadHomepageArticles()
        case .failure(let error): catalogViewController.displayError(error)
        }
    }

    var catalogViewController: CatalogViewController? {
        guard let
            navigationController = window?.rootViewController as? UINavigationController,
            catalogViewController = navigationController.viewControllers.first as? CatalogViewController else { return nil }
        return catalogViewController
    }

}
