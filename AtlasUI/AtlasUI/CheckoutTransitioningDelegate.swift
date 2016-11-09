//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

final class CheckoutTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    #if swift(>=2.3)

        func presentationControllerForPresentedViewController(presented: UIViewController,
                                                              presentingViewController presenting: UIViewController?,
                                                              sourceViewController source: UIViewController) -> UIPresentationController? {
            return CheckoutPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }

    #else

        func presentationControllerForPresentedViewController(presented: UIViewController,
                                                              presentingViewController presenting: UIViewController,
                                                              sourceViewController source: UIViewController) -> UIPresentationController? {
            return CheckoutPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }

    #endif

}
