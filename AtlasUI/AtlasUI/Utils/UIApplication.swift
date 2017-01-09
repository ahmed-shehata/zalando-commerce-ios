//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    static func topViewController(baseController: UIViewController? = nil) -> UIViewController? {
        let baseController = baseController ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = baseController as? UINavigationController {
            return topViewController(baseController: navigationController.visibleViewController)
        }
        if let tabBarController = baseController as? UITabBarController, let selectedController = tabBarController.selectedViewController {
            return topViewController(baseController: selectedController)
        }
        if let presentedController = baseController?.presentedViewController {
            return topViewController(baseController: presentedController)
        }
        return baseController
    }

    static var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    static var unitTestsAreRunning: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

}
