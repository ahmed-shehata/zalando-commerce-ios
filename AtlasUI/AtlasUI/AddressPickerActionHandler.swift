//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressPickerActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy? { get set }

    func createAddress()
    func selectAddress(address: EquatableAddress)
    func updateAddress(address: EquatableAddress)
    func deleteAddress(address: EquatableAddress)

}
