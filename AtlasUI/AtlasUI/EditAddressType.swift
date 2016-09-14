//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum EditAddressType {
    case StandardAddress
    case PickupPoint

    var fields: [EditAddressField] {
        switch self {
        case .StandardAddress: return [.Title, .FirstName, .LastName, .Street, .Additional, .Zipcode, .City, .Country]
        case .PickupPoint: return [.Title, .FirstName, .LastName, .Packstation, .MemberID, .Zipcode, .City, .Country]
        }
    }
}

enum EditAddressField {
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

    func title(localizer: LocalizerProviderType) -> String {
        switch self {
        case .Title: return localizer.loc("Address.edit.title")
        case .FirstName: return localizer.loc("Address.edit.firstName")
        case .LastName: return localizer.loc("Address.edit.lastName")
        case .Street: return localizer.loc("Address.edit.street")
        case .Additional: return localizer.loc("Address.edit.additional")
        case .Packstation: return localizer.loc("Address.edit.packstation")
        case .MemberID: return localizer.loc("Address.edit.memberID")
        case .Zipcode: return localizer.loc("Address.edit.zipcode")
        case .City: return localizer.loc("Address.edit.city")
        case .Country: return localizer.loc("Address.edit.country")
        }
    }

    func value(viewModel: EditAddressViewModel, localizer: LocalizerProviderType) -> String? {
        switch self {
        case .Title: return viewModel.localizedTitle(localizer)
        case .FirstName: return viewModel.firstName
        case .LastName: return viewModel.lastName
        case .Street: return viewModel.street
        case .Additional: return viewModel.additional
        case .Packstation: return viewModel.pickupPointName
        case .MemberID: return viewModel.pickupPointMemberId
        case .Zipcode: return viewModel.zip
        case .City: return viewModel.city
        case .Country: return localizer.localizer.countryName(forCountryCode: viewModel.countryCode)
        }
    }

    func updateModel(viewModel: EditAddressViewModel, withValue value: String?, localizer: LocalizerProviderType) {
        switch self {
        case .Title: viewModel.updateTitle(value, localizer: localizer)
        case .FirstName: viewModel.firstName = value
        case .LastName: viewModel.lastName = value
        case .Street: viewModel.street = value
        case .Additional: viewModel.additional = value
        case .Packstation: viewModel.pickupPointName = value
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

    func customView(viewModel: EditAddressViewModel, localizer: LocalizerProviderType, completion: TextFieldChangedHandler) -> UIView? {
        switch self {
        case .Title:
            return PickerKeyboardInputView(pickerData: viewModel.titles(localizer), completion: completion)
        default:
            return nil
        }
    }
}
