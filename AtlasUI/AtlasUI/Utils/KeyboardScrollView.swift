//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class KeyboardScrollView: UIScrollView {

    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillShow(_:)),
                                                         name: UIKeyboardWillShowNotification,
                                                         object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardWillHide(_:)),
                                                         name: UIKeyboardWillHideNotification,
                                                         object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height else { return }

        UIView.animate(.fast) {
            self.contentInset.bottom = keyboardHeight
            self.scrollIndicatorInsets.bottom = keyboardHeight
            self.scrollToCurrentFirstResponder(withKeyboardHeight: keyboardHeight)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(.fast) {
            self.contentInset.bottom = 0
            self.scrollIndicatorInsets.bottom = 0
        }
    }

    private func scrollToCurrentFirstResponder(withKeyboardHeight keyboardHeight: CGFloat) {
        guard let firstResponder = UIApplication.window?.findFirstResponder() else { return }

        let frame = firstResponder.convertRect(firstResponder.bounds, toView: self)
        let newOffset = frame.origin.y - (bounds.height - keyboardHeight) / 2.0
        let maxOffset = contentSize.height + keyboardHeight - bounds.height
        contentOffset.y = max(-contentInset.top, min(newOffset, maxOffset))
    }

}
