//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

extension UIViewController {

    func showCancelButton() {
        let button = UIBarButtonItem(title: Localizer.string("Cancel"),
                                     style: .Plain,
                                     target: self,
                                     action: #selector(UIViewController.cancelCheckoutTapped))
        button.accessibilityIdentifier = "navigation-bar-cancel-button"
        navigationItem.rightBarButtonItem = button

        navigationController?.navigationBar.translucent = false
    }

    func hideCancelButton() {
        navigationItem.rightBarButtonItem = nil
    }

    private dynamic func cancelCheckoutTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
