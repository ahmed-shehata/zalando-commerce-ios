//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias ButtonActionHandler = ((UIAlertAction) -> Void)

struct ButtonAction {

    let text: String
    let handler: ButtonActionHandler?
    let style: UIAlertActionStyle

    init(text: String, style: UIAlertActionStyle = .Default, handler: ButtonActionHandler? = nil) {
        self.text = text
        self.handler = handler
        self.style = style
    }

}

struct UserMessage {

    static func show(error error: ErrorType) {
        AtlasLogger.logError(error)

        let title: String
        let message: String
        if let userPresentable = error as? UserPresentable {
            message = userPresentable.message()
            title = userPresentable.title()
        } else {
            message = String(error)
            title = UILocalizer.string("Error")
        }

        show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    static func notImplemented() {
        AtlasLogger.logError("Not Implemented")
        let title = UILocalizer.string("feature.notImplemented.title")
        let message = UILocalizer.string("feature.notImplemented.message")
        show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    static func showOK(title title: String) {
        show(title: title, message: nil, actions: ButtonAction(text: "OK"))
    }

    static func show(title title: String, message: String? = nil,
        preferredStyle: UIAlertControllerStyle = .Alert, actions: ButtonAction...) {
            guard let topViewController = UIApplication.topViewController() else { return }
            let alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            actions.forEach { alertView.addAction($0) }

            Async.main {
                topViewController.presentViewController(alertView, animated: true, completion: nil)
            }
    }

    static func unclasifiedError(error: ErrorType) {
        AtlasLogger.logError("Unclasified Error", error)

        let title = UILocalizer.string("Error.unclasified.title")
        let message = UILocalizer.string("Error.unclasified.message")
        show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

}

private extension UIAlertController {

    func addAction(button: ButtonAction) {
        let title = UILocalizer.string(button.text)
        let action = UIAlertAction(title: title, style: button.style, handler: button.handler)
        self.addAction(action)
    }

}
