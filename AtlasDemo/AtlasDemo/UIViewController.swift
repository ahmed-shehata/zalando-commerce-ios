//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

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

    func showOK(title title: String, message: String) {
        showMessage(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    func showError(title title: String, error: ErrorType) {
        showMessage(title: title, message: String(error), actions: ButtonAction(text: "OK"))
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
