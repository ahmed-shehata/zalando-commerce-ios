//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressFormLayout {

    var displayCancelButton: Bool { get }
    var displayViewModally: Bool { get }

}

struct CreateAddressFormLayout: AddressFormLayout {

    let displayCancelButton: Bool = true
    let displayViewModally: Bool = true

}

struct UpdateAddressFormLayout: AddressFormLayout {

    let displayCancelButton: Bool = false
    var displayViewModally: Bool = false

}
