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

extension AddressListActionHandler {

    func createAddress(withStrategy: AddressViewModelCreationStrategy?, formActionHandler actionHandler: AddressFormActionHandler) {
        withStrategy?.setStrategyCompletion() { viewModel in
            self.showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { address in
                self.delegate?.addressCreated(address)
            }
        }
        withStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress, formActionHandler actionHandler: AddressFormActionHandler) {
        let dataModel = AddressFormDataModel(equatableAddress: address, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .standardAddress : .pickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { address in
            self.delegate?.addressUpdated(address)
        }
    }

    private func showAddressViewController(withViewModel viewModel: AddressFormViewModel,
                                                         formActionHandler: AddressFormActionHandler,
                                                         completion: AddressFormCompletion) {

        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: formActionHandler, completion: completion)
        viewController.displayView()
    }

}
