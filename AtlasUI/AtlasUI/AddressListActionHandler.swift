//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressListActionHandlerDelegate: NSObjectProtocol {

    func addressCreated(address: EquatableAddress)
    func addressUpdated(address: EquatableAddress)
    func addressDeleted(address: EquatableAddress)

}

protocol AddressListActionHandler {

    weak var delegate: AddressListActionHandlerDelegate? { get set }

    init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?)
    func createAddress()
    func updateAddress(address: EquatableAddress)
    func deleteAddress(address: EquatableAddress)

}
