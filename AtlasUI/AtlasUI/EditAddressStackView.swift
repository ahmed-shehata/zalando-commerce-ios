//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class EditAddressStackView: UIStackView {

    private var textFields: [(type: EditAddressField, textField: TextFieldInputStackView)]

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

    private let addressType: EditAddressType

    init(addressType: EditAddressType) {
        self.addressType = addressType
        self.textFields = []
        super.init(arrangedSubviews: [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension EditAddressStackView: UIBuilder {

    func configureView() {
        addressType.fields.forEach {
            let textField = TextFieldInputStackView()
            self.textFields.append((type: $0, textField: textField))
            self.addArrangedSubview(textField)
        }
        submitButtonStackView.addArrangedSubview(submitButton)
    }

    func builderSubviews() -> [UIBuilder] {
        return textFields.map { $0.textField }
    }

}

extension EditAddressStackView: UIDataBuilder {

    typealias T = EditAddressViewModel

    func configureData(viewModel: T) {
        
        titleTextFieldInput.configureData(TextFieldInputViewModel(title: "Title", value: nil, error: nil, nextTextFieldInput: firstNameTextFieldInput))
        firstNameTextFieldInput.configureData(TextFieldInputViewModel(title: "First Name", value: nil, error: nil, nextTextFieldInput: lastNameTextFieldInput))
        lastNameTextFieldInput.configureData(TextFieldInputViewModel(title: "Last Name", value: nil, error: nil, nextTextFieldInput: streetTextFieldInput))
        streetTextFieldInput.configureData(TextFieldInputViewModel(title: "Street", value: nil, error: nil, nextTextFieldInput: additionalAddressTextFieldInput))
        additionalAddressTextFieldInput.configureData(TextFieldInputViewModel(title: "Additional", value: nil, error: nil, nextTextFieldInput: zipcodeTextFieldInput))
        zipcodeTextFieldInput.configureData(TextFieldInputViewModel(title: "Zipcode", value: nil, error: nil, nextTextFieldInput: cityTextFieldInput))
        cityTextFieldInput.configureData(TextFieldInputViewModel(title: "City", value: nil, error: nil, nextTextFieldInput: countryTextFieldInput))
        countryTextFieldInput.configureData(TextFieldInputViewModel(title: "Country", value: nil, error: nil, nextTextFieldInput: nil))
        submitButton.setTitle("Save Address", forState: .Normal)
    }

}
