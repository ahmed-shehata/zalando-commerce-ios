//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

typealias ButtonActionHandler = ((UIAlertAction) -> Void)

struct ButtonAction {

    let text: String
    let handler: ButtonActionHandler?
    let style: UIAlertActionStyle

    init(text: String, style: UIAlertActionStyle = .default, handler: ButtonActionHandler? = nil) {
        self.text = text
        self.handler = handler
        self.style = style
    }

}

struct UserMessage {

    static func display(title: String? = nil, message: String? = nil, actions: [ButtonAction]) {
        guard let topViewController = UIApplication.topViewController() else { return }
        let style: UIAlertControllerStyle = UIDevice.isPad ? .alert : .actionSheet
        let alertView = UIAlertController(title: title, message: message, preferredStyle: style)

        actions.forEach { alertView.add(button: $0) }

        Async.main {
            topViewController.present(alertView, animated: true, completion: nil)
        }
    }

}

extension UIAlertController {

    fileprivate func add(button: ButtonAction) {
        let title = Localizer.format(string: button.text)
        let action = UIAlertAction(title: title, style: button.style, handler: button.handler)
        self.addAction(action)
    }

}
