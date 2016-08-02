//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public struct AtlasCheckout {

    public static func presentCheckout(sku sku: String) {
        if let presentingViewController = UIApplication.topViewController() {
            presentCheckoutViewOnViewController(presentingViewController, sku: sku)
        }
    }

    public static func presentCheckoutViewOnViewController(viewController: UIViewController, sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(sku: sku)
        let checkoutTransitioning = CheckoutTransitioningDelegate()
        let navigationController = UINavigationController(rootViewController: sizeSelectionViewController)
        navigationController.transitioningDelegate = checkoutTransitioning
        navigationController.modalPresentationStyle = .Custom
        viewController.presentViewController(navigationController, animated: true, completion: nil)
    }

}
