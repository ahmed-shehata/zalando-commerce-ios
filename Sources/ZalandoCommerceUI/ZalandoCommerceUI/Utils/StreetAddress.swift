//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

extension StreetAddress {

    var addressLine1: String {
        return (isBillingAllowed ? street : pickupPoint?.localizedTitle) ?? ""
    }

    var addressLine2: String {
        return (isBillingAllowed ? additional : pickupPoint?.localizedValue) ?? ""
    }

    var shortAddressLine: String {
        return [addressLine1, addressLine2].filter { !$0.isEmpty }.joined(separator: ", ")
    }

}
