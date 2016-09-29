//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias TextFieldChangedHandler = String? -> Void

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let accessibilityIdentifier: String
    let isActive: Bool
    let validators: [FormValidator]
    let customInputView: UIView?
    let nextTextFieldInput: TextFieldInputStackView?
    let valueChangedHandler: TextFieldChangedHandler?

    init (title: String,
        value: String? = nil,
        accessibilityIdentifier: String,
        isActive: Bool = true,
        validators: [FormValidator] = [],
        customInputView: UIView? = nil,
        nextTextFieldInput: TextFieldInputStackView? = nil,
        valueChangedHandler: TextFieldChangedHandler? = nil) {

            self.title = title
            self.value = value
            self.accessibilityIdentifier = accessibilityIdentifier
            self.isActive = isActive
            self.validators = validators
            self.customInputView = customInputView
            self.nextTextFieldInput = nextTextFieldInput
            self.valueChangedHandler = valueChangedHandler
    }
}
