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

    func configure(viewModel: T) {
        for (idx, textFieldInputView) in textFields.enumerated() {
            let fieldType = addressType.fields[idx]
            let title = fieldType.title
            let value = viewModel.value(forField: fieldType)
            let isActive = fieldType.isActive()

            let customView = fieldType.customView(from: viewModel) { text in
                viewModel.update(value: text, fromField: fieldType)
                textFieldInputView.textField.text = text
                textFieldInputView.configureTitleLabel()
                if let trimmed = text?.trimmed(), trimmed.length > 0 {
                    textFieldInputView.textField.resignFirstResponder()
                }
            }

            var nextTextField: TextFieldInputStackView?
            if !fieldType.returnKeyDismissKeyboard() {
                nextTextField = textFields.count > idx + 1 ? textFields[idx + 1]: nil
            }

            let valueChangedHandler: TextFieldChangedHandler = { text in
                viewModel.update(value: text, fromField: fieldType)
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
