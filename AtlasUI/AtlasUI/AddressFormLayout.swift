//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressFormLayout {

    var displayCancelButton: Bool { get }
    var dismissViewByPoping: Bool { get }

}

struct CreateAddressFormLayout: AddressFormLayout {

    let displayCancelButton: Bool = true
    let dismissViewByPoping: Bool = false

}

struct UpdateAddressFormLayout: AddressFormLayout {

    let displayCancelButton: Bool = false
    var dismissViewByPoping: Bool = true

}
