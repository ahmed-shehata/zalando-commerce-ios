//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum EditAddressType {
    case NormalAddress
    case PickupPoint

    var fields: [EditAddressField] {
        switch self {
        case .NormalAddress: return [.Title, .FirstName, .LastName, .Street, .Additional, .Zipcode, .City, .Country]
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
        case .Title: return viewModel.gender?.addressFormTitle(localizer)
        case .FirstName: return viewModel.firstName
        case .LastName: return viewModel.lastName
        case .Street: return viewModel.street
        case .Additional: return viewModel.additional
        case .Packstation: return viewModel.pickupPoint?.name
        case .MemberID: return viewModel.pickupPoint?.memberId
        case .Zipcode: return viewModel.zip
        case .City: return viewModel.city
        case .Country: return viewModel.countryCode
        }
    }
}
