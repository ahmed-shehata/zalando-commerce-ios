//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

internal final class CheckoutTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
        return CheckoutPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

}
