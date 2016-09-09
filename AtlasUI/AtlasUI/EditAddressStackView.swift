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
        for (idx, textField) in textFields.enumerate() {
            let fieldType = addressType.fields[idx]
            let title = fieldType.title(checkoutProviderType)
            let value = fieldType.value(viewModel, localizer: checkoutProviderType)
            let nextTextField: TextFieldInputStackView? = textFields.count > idx+1 ? textFields[idx+1] : nil
            let viewModel = TextFieldInputViewModel(title: title, value: value, nextTextFieldInput: nextTextField)
            textField.configureData(viewModel)
        }
    }

}
