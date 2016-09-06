//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class EditAddressStackView: UIStackView {

    internal let titleTextFieldInput = TextFieldInputStackView()
    internal let firstNameTextFieldInput = TextFieldInputStackView()
    internal let lastNameTextFieldInput = TextFieldInputStackView()
    internal let streetTextFieldInput = TextFieldInputStackView()
    internal let additionalAddressTextFieldInput = TextFieldInputStackView()
    internal let zipcodeTextFieldInput = TextFieldInputStackView()
    internal let cityTextFieldInput = TextFieldInputStackView()
    internal let countryTextFieldInput = TextFieldInputStackView()

    internal let submitButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 40, left: 30, bottom: 20, right: 30)
        stackView.layoutMarginsRelativeArrangement = true
        return stackView
    }()

    internal let submitButton: RoundedButton = {
        let button = RoundedButton(type: .Custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFontOfSize(15)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor(hex: 0x519415)
        return button
    }()

}

extension EditAddressStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(titleTextFieldInput)
        addArrangedSubview(firstNameTextFieldInput)
        addArrangedSubview(lastNameTextFieldInput)
        addArrangedSubview(streetTextFieldInput)
        addArrangedSubview(additionalAddressTextFieldInput)
        addArrangedSubview(zipcodeTextFieldInput)
        addArrangedSubview(cityTextFieldInput)
        addArrangedSubview(countryTextFieldInput)
        addArrangedSubview(submitButtonStackView)
        submitButtonStackView.addArrangedSubview(submitButton)
    }

    func builderSubviews() -> [UIBuilder] {
        return [titleTextFieldInput, firstNameTextFieldInput, lastNameTextFieldInput, streetTextFieldInput, additionalAddressTextFieldInput, zipcodeTextFieldInput, cityTextFieldInput, countryTextFieldInput]
    }

}

extension EditAddressStackView: UIDataBuilder {

    typealias T = Bool

    func configureData(viewModel: T) {
        titleTextFieldInput.configureData(TextFieldInputViewModel(title: "Title", value: nil, placeholder: "Mrs"))
        firstNameTextFieldInput.configureData(TextFieldInputViewModel(title: "First Name", value: nil, placeholder: "John"))
        lastNameTextFieldInput.configureData(TextFieldInputViewModel(title: "Last Name", value: nil, placeholder: "Doe"))
        streetTextFieldInput.configureData(TextFieldInputViewModel(title: "Street", value: nil, placeholder: "Mollstr. 1"))
        additionalAddressTextFieldInput.configureData(TextFieldInputViewModel(title: "Additional", value: nil, placeholder: "Zalando BMO"))
        zipcodeTextFieldInput.configureData(TextFieldInputViewModel(title: "Zipcode", value: nil, placeholder: "12345"))
        cityTextFieldInput.configureData(TextFieldInputViewModel(title: "City", value: nil, placeholder: "Berlin"))
        countryTextFieldInput.configureData(TextFieldInputViewModel(title: "Country", value: nil, placeholder: "Deutschland"))
        submitButton.setTitle("Save Address", forState: .Normal)
    }

}
