//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum AddressFormMode {
    case createAddress
    case updateAddress(address: EquatableAddress)
}

enum AddressFormType {
    case standardAddress
    case pickupPoint

    var fields: [AddressFormField] {
        switch self {
        case .standardAddress: return [.title, .firstName, .lastName, .street, .additional, .zipcode, .city, .country]
        case .pickupPoint: return [.title, .firstName, .lastName, .packstation, .memberID, .zipcode, .city, .country]
        }
    }
}

enum AddressFormField: String {
    case title
    case firstName
    case lastName
    case street
    case additional
    case packstation
    case memberID
    case zipcode
    case city
    case country

    var accessibilityIdentifier: String {
        return "\(rawValue.lowercaseString)-textfield"
    }

    var title: String {
        let title = Localizer.string("Address.form.\(rawValue.lowercaseString)")
        return title + (formValidators.contains { $0 == .Required } ? "*" : "")
    }

    func value(viewModel: AddressFormViewModel) -> String? {
        switch self {
        case .title: return viewModel.localizedTitle()
        case .firstName: return viewModel.firstName
        case .lastName: return viewModel.lastName
        case .street: return viewModel.street
        case .additional: return viewModel.additional
        case .packstation: return viewModel.pickupPointId
        case .memberID: return viewModel.pickupPointMemberId
        case .zipcode: return viewModel.zip
        case .city: return viewModel.city
        case .country: return Localizer.countryName(forCountryCode: viewModel.countryCode)
        }
    }

    func updateModel(viewModel: AddressFormViewModel, withValue value: String?) {
        switch self {
        case .title: viewModel.updateTitle(value)
        case .firstName: viewModel.firstName = value
        case .lastName: viewModel.lastName = value
        case .street: viewModel.street = value
        case .additional: viewModel.additional = value
        case .packstation: viewModel.pickupPointId = value
        case .memberID: viewModel.pickupPointMemberId = value
        case .zipcode: viewModel.zip = value
        case .city: viewModel.city = value
        case .country: break
        }
    }

    func isActive() -> Bool {
        return self != .country
    }

    func returnKeyDismissKeyboard() -> Bool {
        switch self {
        case .city, .country: return true
        default: return false
        }
    }

    func customView(viewModel: AddressFormViewModel, completion: TextFieldChangedHandler) -> UIView? {
        switch self {
        case .title:
            let titles = viewModel.titles
            let currentTitle = value(viewModel) ?? ""
            let currentTitleIdx = titles.indexOf(currentTitle) ?? 0
            return PickerKeyboardInputView(pickerData: titles, startingValueIndex: currentTitleIdx, completion: completion)
        default:
            return nil
        }
    }

    var formValidators: [FormValidator] {
        switch self {
        case .title:
            return [.Required]
        case .firstName, .lastName:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.namePattern, errorMessage: "Form.validation.pattern.name")]
        case .street:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.streetPattern, errorMessage: "Form.validation.pattern.street")]
        case .additional:
            return [.MaxLength(maxLength: 50)]
        case .packstation:
            return [.Required,
                    .ExactLength(length: 3),
                    .NumbersOnly]
        case .memberID:
            return [.Required,
                    .MinLength(minLength: 3),
                    .NumbersOnly]
        case .zipcode:
            return [.Required,
                    .ExactLength(length: 5),
                    .NumbersOnly]
        case .city:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.cityPattern, errorMessage: "Form.validation.pattern.city")]
        case .country:
            return [.Required]
        }
    }

}

internal func == (lhs: AddressFormMode, rhs: AddressFormMode) -> Bool {
    switch (lhs, rhs) {
    case (.createAddress, .createAddress): return true
    case (.updateAddress(let lhsAddress), .updateAddress(let rhsAddress)): return lhsAddress == rhsAddress
    default: return false
    }
}
