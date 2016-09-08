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
        case .Title: return localizer.loc("Address.edit.title.title")
        case .FirstName: return localizer.loc("Address.edit.title.firstName")
        case .LastName: return localizer.loc("Address.edit.title.lastName")
        case .Street: return localizer.loc("Address.edit.title.street")
        case .Additional: return localizer.loc("Address.edit.title.additional")
        case .Packstation: return localizer.loc("Address.edit.title.packstation")
        case .MemberID: return localizer.loc("Address.edit.title.memberID")
        case .Zipcode: return localizer.loc("Address.edit.title.zipcode")
        case .City: return localizer.loc("Address.edit.title.city")
        case .Country: return localizer.loc("Address.edit.title.country")
        }
    }
}
