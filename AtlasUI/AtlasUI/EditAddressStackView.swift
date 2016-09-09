//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class EditAddressStackView: UIStackView {

    private let submitButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 40, left: 30, bottom: 20, right: 30)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    private let submitButton: RoundedButton = {
        let button = RoundedButton(type: .Custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(hex: 0x519415)
        return button
    }()

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
        submitButtonStackView.addArrangedSubview(submitButton)
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
        submitButton.setTitle("Save Address", forState: .Normal)
    }

}
