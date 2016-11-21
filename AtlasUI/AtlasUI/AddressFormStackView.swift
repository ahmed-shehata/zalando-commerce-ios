//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddressFormStackView: UIStackView {

    var addressType: AddressFormType!
    var textFields: [TextFieldInputStackView] = []

}

extension AddressFormStackView: UIBuilder {

    func configureView() {
        addressType.fields.forEach { _ in
            let textField = TextFieldInputStackView()
            self.textFields.append(textField)
            self.addArrangedSubview(textField)
        }
    }

}

extension AddressFormStackView: UIDataBuilder {

    typealias T = AddressFormDataModel

    func configure(viewModel: T) {
        for (idx, textFieldInputView) in textFields.enumerated() {
            let fieldType = addressType.fields[idx]
            let title = fieldType.title
            let value = fieldType.value(viewModel)
            let isActive = fieldType.isActive()

            let customView = fieldType.customView(viewModel) { text in
                fieldType.update(dataModel: viewModel, withValue: text)
                textFieldInputView.textField.text = text
                textFieldInputView.configureTitleLabel()
                if text?.trimmed().length > 0 {
                    textFieldInputView.textField.resignFirstResponder()
                }
            }

            var nextTextField: TextFieldInputStackView?
            if !fieldType.returnKeyDismissKeyboard() {
                nextTextField = textFields.count > idx + 1 ? textFields[idx + 1]: nil
            }

            let valueChangedHandler: TextFieldChangedHandler = { text in
                fieldType.update(dataModel: viewModel, withValue: text)
            }

            let viewModel = TextFieldInputViewModel(title: title,
                value: value,
                accessibilityIdentifier: fieldType.accessibilityIdentifier,
                isActive: isActive,
                validators: fieldType.formValidators,
                customInputView: customView,
                nextTextFieldInput: nextTextField,
                valueChangedHandler: valueChangedHandler)
            textFieldInputView.configure(viewModel: viewModel)
        }
    }

}
