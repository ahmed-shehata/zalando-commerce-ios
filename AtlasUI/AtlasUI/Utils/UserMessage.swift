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

    init(localizerProvider: LocalizerProviderType) {
        self.localizerProvider = localizerProvider
    }

    func show(error error: ErrorType, title: String? = nil) {
        AtlasLogger.logError(error)
        let message: String
        if let atlasError = error as? AtlasErrorType {
            message = atlasError.message(localizedWith: localizerProvider)
        } else {
            message = String(error)
        }
        show(title: title ?? localizerProvider.loc("Error"),
            message: message, actions: ButtonAction(text: "OK"))
    }

    func show(title title: String, message: String, actions: ButtonAction...) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for button in actions {
            let title = localizerProvider.loc(button.text)
            alertView.addAction(UIAlertAction(title: title, style: button.style, handler: button.handler))
        }
        Async.main {
            topViewController.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
