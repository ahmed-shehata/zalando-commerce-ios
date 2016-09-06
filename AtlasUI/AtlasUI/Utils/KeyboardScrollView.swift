//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

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
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return }

        UIView.animateWithDuration(0.3) {
            self.contentInset.bottom = frame.height
            self.scrollIndicatorInsets.bottom = frame.height
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.contentInset.bottom = 0
            self.scrollIndicatorInsets.bottom = 0
        }
    }

}
