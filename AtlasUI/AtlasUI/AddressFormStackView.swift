//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

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

    func configureData(viewModel: T) {
        for (idx, textFieldInputView) in textFields.enumerate() {
            let fieldType = addressType.fields[idx]
            let title = fieldType.title
            let value = fieldType.value(viewModel)
            let isActive = fieldType.isActive()

            let customView = fieldType.customView(viewModel) { text in
                fieldType.updateModel(viewModel, withValue: text)
                textFieldInputView.textField.text = text
                textFieldInputView.configureTitleLabel()
                if text?.trimmedLength > 0 {
                    textFieldInputView.textField.resignFirstResponder()
                }
            }

            var nextTextField: TextFieldInputStackView?
            if !fieldType.returnKeyDismissKeyboard() {
                nextTextField = textFields.count > idx + 1 ? textFields[idx + 1]: nil
            }

            let valueChangedHandler: TextFieldChangedHandler = { text in
                fieldType.updateModel(viewModel, withValue: text)
            }

            let viewModel = TextFieldInputViewModel(title: title,
                value: value,
                accessibilityIdentifier: fieldType.accessibilityIdentifier,
                isActive: isActive,
                validators: fieldType.formValidators,
                customInputView: customView,
                nextTextFieldInput: nextTextField,
                valueChangedHandler: valueChangedHandler)
            textFieldInputView.configureData(viewModel)
        }
    }

}
