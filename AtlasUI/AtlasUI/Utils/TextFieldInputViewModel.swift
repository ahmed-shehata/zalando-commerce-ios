//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

typealias TextFieldChangedHandler = (String?) -> Void

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let accessibilityIdentifier: String
    let isActive: Bool
    let validators: [FormValidator]
    let customInputView: UIView?
    let nextTextFieldInput: TextFieldInputStackView?
    let valueChangedHandler: TextFieldChangedHandler?
    let keyboardType: UIKeyboardType

    var autocapitalizationType: UITextAutocapitalizationType {
        return keyboardType != .emailAddress ? .words : .none
    }

    var returnKeyType: UIReturnKeyType {
        return nextTextFieldInput != nil ? .next : .default
    }

    init(title: String,
         value: String? = nil,
         accessibilityIdentifier: String,
         isActive: Bool = true,
         validators: [FormValidator] = [],
         customInputView: UIView? = nil,
         nextTextFieldInput: TextFieldInputStackView? = nil,
         valueChangedHandler: TextFieldChangedHandler? = nil,
         keyboardType: UIKeyboardType) {

        self.title = title
        self.value = value
        self.accessibilityIdentifier = accessibilityIdentifier
        self.isActive = isActive
        self.validators = validators
        self.customInputView = customInputView
        self.nextTextFieldInput = nextTextFieldInput
        self.valueChangedHandler = valueChangedHandler
        self.keyboardType = keyboardType
    }
}

extension ActionTextField {

    func setup(from viewModel: TextFieldInputViewModel) {
        self.text = viewModel.value
        self.accessibilityIdentifier = viewModel.accessibilityIdentifier
        self.placeholder = viewModel.title
        self.keyboardType = viewModel.keyboardType

        self.autocapitalizationType = viewModel.autocapitalizationType
        self.returnKeyType = viewModel.returnKeyType

        self.isUserInteractionEnabled = viewModel.isActive
        if !viewModel.isActive {
            self.textColor = UIColor(hex: 0xADADAD)
        }

        self.inputView = viewModel.customInputView
        if viewModel.customInputView != nil {
            self.tintColor = .clear
            self.canCopy = false
            self.canPaste = false
        }
    }

}
