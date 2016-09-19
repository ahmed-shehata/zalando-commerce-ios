//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class EditAddressStackView: UIStackView {

    internal var addressType: EditAddressType!
    internal var checkoutProviderType: CheckoutProviderType!
    internal var textFields: [TextFieldInputStackView] = []

}

extension EditAddressStackView: UIBuilder {

    func configureView() {
        addressType.fields.forEach { _ in
            let textField = TextFieldInputStackView()
            self.textFields.append(textField)
            self.addArrangedSubview(textField)
        }
    }

    func builderSubviews() -> [UIBuilder] {
        return textFields.map { $0 }
    }

}

extension EditAddressStackView: UIDataBuilder {

    typealias T = EditAddressViewModel

    func configureData(viewModel: T) {
        for (idx, textFieldInputView) in textFields.enumerate() {
            let fieldType = addressType.fields[idx]
            let title = fieldType.title(checkoutProviderType)
            let value = fieldType.value(viewModel, localizer: checkoutProviderType)
            let isActive = fieldType.isActive()

            let customView = fieldType.customView(viewModel, localizer: checkoutProviderType) { [weak self] text in
                guard let strongSelf = self else { return }
                fieldType.updateModel(viewModel, withValue: text, localizer: strongSelf.checkoutProviderType)
                textFieldInputView.textField.text = text
                textFieldInputView.configureTitleLabel()
                if text?.trimmedLength > 0 {
                    textFieldInputView.textField.resignFirstResponder()
                }
            }

            var nextTextField: TextFieldInputStackView?
            if !fieldType.returnKeyDismissKeyboard() {
                nextTextField = textFields.count > idx+1 ? textFields[idx+1] : nil
            }

            let valueChangedHandler: TextFieldChangedHandler = { [weak self] text in
                guard let strongSelf = self else { return }
                fieldType.updateModel(viewModel, withValue: text, localizer: strongSelf.checkoutProviderType)
            }

            let viewModel = TextFieldInputViewModel(title: title,
                                                    value: value,
                                                    isActive: isActive,
                                                    validators: fieldType.formValidators,
                                                    localizer: checkoutProviderType,
                                                    customInputView: customView,
                                                    nextTextFieldInput: nextTextField,
                                                    valueChangedHandler: valueChangedHandler)
            textFieldInputView.configureData(viewModel)
        }
    }

}
