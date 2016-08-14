//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

public extension UIApplication {

    public class var hasTopViewController: Bool {
        return topViewController() != nil
    }

    public class func topViewController(baseController: UIViewController? = nil) -> UIViewController? {
        let baseController = baseController ?? UIApplication.sharedApplication().keyWindow?.rootViewController
        if let navigationController = baseController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabBarController = baseController as? UITabBarController, selectedController = tabBarController.selectedViewController {
            return topViewController(selectedController)
        }
        if let presentedController = baseController?.presentedViewController {
            return topViewController(presentedController)
        }
        return baseController
    }

}
