//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressListActionHandlerDelegate: NSObjectProtocol {

    func emailUpdated(email: String)
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

extension AddressListActionHandler {

    func showAddressViewController(withViewModel viewModel: AddressFormViewModel,
                                                 formActionHandler: AddressFormActionHandler,
                                                 completion: AddressFormCompletion) {

        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: formActionHandler, completion: completion)
        viewController.displayView()
    }

}
