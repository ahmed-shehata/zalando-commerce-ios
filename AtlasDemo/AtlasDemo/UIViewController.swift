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
        var message: String?
        let unclassifiedMessage = "Something went wrong.\nWe are fixing the issue.\nPlease come back later"

        switch error {
        case AtlasAPIError.noInternet: message = "Please check you internet connection"
        case AtlasAPIError.unauthorized: message = "Access denied"
        case AtlasAPIError.nsURLError(_, let details): message = details
        case AtlasAPIError.http(_, let details): message = details
        case AtlasAPIError.backend(_, _, _, let details): message = details
        case LoginError.accessDenied: message = "Access denied"
        case LoginError.requestFailed(let error): message = error?.localizedDescription
        case ArticlesError.Error(let error): message = (error as NSError).localizedDescription
        default: message = unclassifiedMessage
        }

        showMessage(title: "Oops", message: message ?? unclassifiedMessage, actions: ButtonAction(text: "OK"))
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
