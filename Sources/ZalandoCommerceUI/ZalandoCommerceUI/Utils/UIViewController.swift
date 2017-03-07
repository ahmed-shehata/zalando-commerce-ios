//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

extension UIViewController {

    func showCancelButton() {
        let button = UIBarButtonItem(title: Localizer.format(string: "button.general.cancel"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(UIViewController.cancelCheckoutTapped))
        button.accessibilityIdentifier = "navigation-bar-cancel-button"
        navigationItem.rightBarButtonItem = button
    }

    func hideCancelButton() {
        navigationItem.rightBarButtonItem = nil
    }

    fileprivate dynamic func cancelCheckoutTapped() {
        ZalandoCommerceUIViewController.presented?.dismissalReason = ZalandoCommerceUI.CheckoutResult.userCancelled
        try? ZalandoCommerceUIViewController.presented?.dismissAtlasCheckoutUI()
    }

}
