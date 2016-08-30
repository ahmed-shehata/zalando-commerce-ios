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

    let localizerProvider: LocalizerProviderType

    func show(error error: ErrorType) {
        AtlasLogger.logError(error)

        let title: String
        let message: String
        if let userPresentable = error as? UserPresentable {
            message = userPresentable.message(localizedWith: localizerProvider)
            title = userPresentable.title(localizedWith: localizerProvider)
        } else {
            message = String(error)
            title = localizerProvider.loc("Error")
        }

        show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

    func show(title title: String, message: String, actions: ButtonAction...) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        actions.forEach { alertView.addAction($0, localizerProvider: localizerProvider) }

        Async.main {
            topViewController.presentViewController(alertView, animated: true, completion: nil)
        }
    }

    func notImplemented() {
        AtlasLogger.logError("Not Implemented")
        let title = localizerProvider.loc("feature.notImplemented.title")
        let message = localizerProvider.loc("feature.notImplemented.message")
        show(title: title, message: message, actions: ButtonAction(text: "OK"))
    }

}

private extension UIAlertController {

    func addAction(button: ButtonAction, localizerProvider: LocalizerProviderType) {
        let title = localizerProvider.loc(button.text)
        let action = UIAlertAction(title: title, style: button.style, handler: button.handler)
        self.addAction(action)
    }

}
