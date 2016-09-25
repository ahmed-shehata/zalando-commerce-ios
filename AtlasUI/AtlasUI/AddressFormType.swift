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
    case StandardAddress
    case PickupPoint

    var fields: [AddressFormField] {
        switch self {
        case .StandardAddress: return [.Title, .FirstName, .LastName, .Street, .Additional, .Zipcode, .City, .Country]
        case .PickupPoint: return [.Title, .FirstName, .LastName, .Packstation, .MemberID, .Zipcode, .City, .Country]
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

    func title(localizer: Localizer) -> String {
        let title = localizer.loc("Address.form.\(rawValue.lowercaseString)")
        return title + (formValidators.contains { $0 == .Required } ? "*" : "")
    }

    func value(viewModel: AddressFormViewModel, localizer: Localizer) -> String? {
        switch self {
        case .Title: return viewModel.localizedTitle(localizer)
        case .FirstName: return viewModel.firstName
        case .LastName: return viewModel.lastName
        case .Street: return viewModel.street
        case .Additional: return viewModel.additional
        case .Packstation: return viewModel.pickupPointId
        case .MemberID: return viewModel.pickupPointMemberId
        case .Zipcode: return viewModel.zip
        case .City: return viewModel.city
        case .Country: return localizer.localizer.countryName(forCountryCode: viewModel.countryCode)
        }
    }

    func updateModel(viewModel: AddressFormViewModel, withValue value: String?, localizer: Localizer) {
        switch self {
        case .Title: viewModel.updateTitle(value, localizer: localizer)
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
        switch self {
        case .Country: return false
        default: return true
        }
    }

    func returnKeyDismissKeyboard() -> Bool {
        switch self {
        case .City, .Country: return true
        default: return false
        }
    }

    func customView(viewModel: AddressFormViewModel, localizer: Localizer, completion: TextFieldChangedHandler) -> UIView? {
        switch self {
        case .Title:
            let titles = viewModel.titles(localizer)
            let currentTitle = value(viewModel, localizer: localizer) ?? ""
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
                    .Pattern(pattern: "^[' \\w-]+$")]
        case .LastName:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .Pattern(pattern: "^[' \\w-]+$")]
        case .Street:
            return [.Required,
                    .MaxLength(maxLength: 50),
                    .Pattern(pattern: "^(?=.*[a-zA-Z])(?=.*[0-9]).*$")]
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
                    .Pattern(pattern: "^[,;()'0-9 \\w-]+$")]
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
