//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

extension UIViewController {

    func showCancelButton() {
        let button = UIBarButtonItem(title: Localizer.string("button.general.cancel"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(UIViewController.cancelCheckoutTapped))
        button.accessibilityIdentifier = "navigation-bar-cancel-button"
        navigationItem.rightBarButtonItem = button

        navigationController?.navigationBar.isTranslucent = false
    }

    func hideCancelButton() {
        navigationItem.rightBarButtonItem = nil
    }

    fileprivate dynamic func cancelCheckoutTapped() {
        dismiss(animated: true, completion: nil)
    }

}
