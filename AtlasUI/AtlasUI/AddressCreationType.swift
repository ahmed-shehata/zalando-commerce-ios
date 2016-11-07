//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum AddressCreationType {

    case standard
    case addressBookImport (strategy: ImportAddressBookStrategy)
    case pickupPoint

    var localizedTitleKey: String {
        switch self {
        case .standard: return "addressListView.add.type.standard"
        case .addressBookImport: return "addressListView.add.type.addressBookImport"
        case .pickupPoint: return "addressListView.add.type.pickupPoint"
        }
    }

}
