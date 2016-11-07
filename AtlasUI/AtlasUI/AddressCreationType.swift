//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum AddressCreationType {

    case standard
    case pickupPoint
    case addressBookImport (strategy: ImportAddressBookStrategy)

    var localizedTitleKey: String {
        switch self {
        case .standard: return "addressListView.add.type.standard"
        case .pickupPoint: return "addressListView.add.type.pickupPoint"
        case .addressBookImport: return "addressListView.add.type.addressBookImport"
        }
    }

}
