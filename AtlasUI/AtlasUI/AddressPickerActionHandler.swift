//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressPickerActionHandler {

    func createAddress()
    func selectAddress(address: EquatableAddress)
    func updateAddress(address: EquatableAddress)
    func deleteAddress(address: EquatableAddress)

}
