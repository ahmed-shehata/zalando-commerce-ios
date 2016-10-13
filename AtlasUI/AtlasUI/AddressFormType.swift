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
        case .standardAddress: return [.Title, .FirstName, .LastName, .Street, .Additional, .Zipcode, .City, .Country]
        case .pickupPoint: return [.Title, .FirstName, .LastName, .Packstation, .MemberID, .Zipcode, .City, .Country]
        }
    }
}

enum AddressFormField: String {
    case Title
    case FirstName
    case LastName
    case Street
    case Additional
    case Packstation
    case MemberID
    case Zipcode
    case City
    case Country

    var accessibilityIdentifier: String {
        return "\(rawValue.lowercaseString)-textfield"
    }

    var title: String {
        let title = Localizer.string("Address.form.\(rawValue.lowercaseString)")
        return title + (formValidators.contains { $0 == .Required } ? "*" : "")
    }

    func value(viewModel: AddressFormViewModel) -> String? {
        switch self {
        case .Title: return viewModel.localizedTitle()
        case .FirstName: return viewModel.firstName
        case .LastName: return viewModel.lastName
        case .Street: return viewModel.street
        case .Additional: return viewModel.additional
        case .Packstation: return viewModel.pickupPointId
        case .MemberID: return viewModel.pickupPointMemberId
        case .Zipcode: return viewModel.zip
        case .City: return viewModel.city
        case .Country: return Localizer.countryName(forCountryCode: viewModel.countryCode)
        }
    }

    func updateModel(viewModel: AddressFormViewModel, withValue value: String?) {
        switch self {
        case .Title: viewModel.updateTitle(value)
        case .FirstName: viewModel.firstName = value
        case .LastName: viewModel.lastName = value
        case .Street: viewModel.street = value
        case .Additional: viewModel.additional = value
        case .Packstation: viewModel.pickupPointId = value
        case .MemberID: viewModel.pickupPointMemberId = value
        case .Zipcode: viewModel.zip = value
        case .City: viewModel.city = value
        case .Country: break
        }
    }

    func isActive() -> Bool {
        return self != .Country
    }

    func returnKeyDismissKeyboard() -> Bool {
        switch self {
        case .City, .Country: return true
        default: return false
        }
    }

    func customView(viewModel: AddressFormViewModel, completion: TextFieldChangedHandler) -> UIView? {
        switch self {
        case .Title:
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
        case .Title:
            return [.Required]
        case .FirstName:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.namePattern, errorMessage: "Form.validation.pattern.name")]
        case .LastName:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.namePattern, errorMessage: "Form.validation.pattern.name")]
        case .Street:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.streetPattern, errorMessage: "Form.validation.pattern.street")]
        case .Additional:
            return [.MaxLength(maxLength: 50)]
        case .Packstation:
            return [.Required,
                    .ExactLength(length: 3),
                    .NumbersOnly]
        case .MemberID:
            return [.Required,
                    .MinLength(minLength: 3),
                    .NumbersOnly]
        case .Zipcode:
            return [.Required,
                    .ExactLength(length: 5),
                    .NumbersOnly]
        case .City:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .MinLength(minLength: 2),
                    .Pattern(pattern: FormValidator.cityPattern, errorMessage: "Form.validation.pattern.city")]
        case .Country:
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
