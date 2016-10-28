//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasUI
import AtlasSDK

extension UIViewController {

    typealias ButtonActionHandler = ((UIAlertAction) -> Void)

    private struct ButtonAction {

        var text: String
        var handler: ButtonActionHandler?

        init(text: String, handler: ButtonActionHandler? = nil) {
            self.text = text
            self.handler = handler
        }

    }

    func displayError(error: ErrorType) {
        guard let userPresentable = error as? UserPresentable else {
            displayError(AtlasCheckoutError.unclassified)
            return
        }

        showMessage(title: userPresentable.displayedTitle, message: userPresentable.displayedMessage, actions: ButtonAction(text: "OK"))
    }

    private func showMessage(title title: String, message: String, actions: ButtonAction...) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for button in actions {
            alertView.addAction(UIAlertAction(title: button.text, style: .Default, handler: button.handler))
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}

extension NSError: UserPresentable {

    public func customTitle() -> String? {
        return "Error"
    }

    public func customMessage() -> String? {
        return localizedDescription
    }

    public func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

}
