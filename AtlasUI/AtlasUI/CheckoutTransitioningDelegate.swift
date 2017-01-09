//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

final class CheckoutTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CheckoutPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

}
