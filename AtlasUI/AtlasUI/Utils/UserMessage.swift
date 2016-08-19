//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias ButtonActionHandler = ((UIAlertAction) -> Void)

struct ButtonAction {

    var text: String
    var handler: ButtonActionHandler?

    init(text: String, handler: ButtonActionHandler? = nil) {
        self.text = text
        self.handler = handler
    }

}

struct UserMessage {

    static func showOK(title title: String, message: String) {
        UserMessage.show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    static func showError(title title: String, error: ErrorType) {
        AtlasLogger.logError(error)
        UserMessage.show(title: title, message: String(error), actions: ButtonAction(text: "OK"))
    }

    static func show(title title: String, message: String, actions: ButtonAction...) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for button in actions {
            alertView.addAction(UIAlertAction(title: button.text, style: .Default, handler: button.handler))
        }
        Async.main {
            topViewController.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
