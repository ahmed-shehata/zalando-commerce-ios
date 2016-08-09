//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias ButtonActionHandler = ((UIAlertAction) -> Void)

public struct ButtonAction {

    public var text: String
    public var handler: ButtonActionHandler?

    public init(text: String) {
        self.text = text
    }

    public init(text: String, handler: ButtonActionHandler) {
        self.text = text
        self.handler = handler
    }

}

public struct UserMessage {

    public static func showOK(title title: String, message: String) {
        UserMessage.show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    public static func showError(title title: String, error: ErrorType) {
        AtlasLogger.logError(error)
        UserMessage.show(title: title, message: String(error), actions: ButtonAction(text: "OK"))
    }

    public static func show(title title: String, message: String, actions: ButtonAction...) {
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
