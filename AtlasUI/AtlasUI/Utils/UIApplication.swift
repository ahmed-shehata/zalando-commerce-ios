//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIApplication {

    static func topViewController(_ baseController: UIViewController? = nil) -> UIViewController? {
        let baseController = baseController ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = baseController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabBarController = baseController as? UITabBarController, let selectedController = tabBarController.selectedViewController {
            return topViewController(selectedController)
        }
        if let presentedController = baseController?.presentedViewController {
            return topViewController(presentedController)
        }
        return baseController
    }

    static var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }

}
