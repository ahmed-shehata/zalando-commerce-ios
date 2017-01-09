//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

class KeyboardScrollView: UIScrollView {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(fromNotification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(fromNotification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    func keyboardWillShow(fromNotification notification: Notification) {
        guard let infoValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] else { return }
        let keyboardHeight = (infoValue as AnyObject).cgRectValue.height

        UIView.animate {
            self.contentInset.bottom = keyboardHeight
            self.scrollIndicatorInsets.bottom = keyboardHeight
            self.scrollToCurrentFirstResponder(withKeyboardHeight: keyboardHeight)
        }
    }

    func keyboardWillHide(fromNotification notification: Notification) {
        UIView.animate {
            self.contentInset.bottom = 0
            self.scrollIndicatorInsets.bottom = 0
        }
    }

    fileprivate func scrollToCurrentFirstResponder(withKeyboardHeight keyboardHeight: CGFloat) {
        guard let firstResponder = UIApplication.window?.findFirstResponder() else { return }

        let frame = firstResponder.convert(firstResponder.bounds, to: self)
        let newOffset = frame.origin.y - (bounds.height - keyboardHeight) / 2.0
        let maxOffset = contentSize.height + keyboardHeight - bounds.height
        contentOffset.y = max(-contentInset.top, min(newOffset, maxOffset))
    }

}
