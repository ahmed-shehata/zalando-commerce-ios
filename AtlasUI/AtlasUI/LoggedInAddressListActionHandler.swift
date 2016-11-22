//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class LoggedInAddressListActionHandler: AddressListActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy?
    weak var delegate: AddressListActionHandlerDelegate?

    required init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?) {
        self.addressViewModelCreationStrategy = addressViewModelCreationStrategy
    }

    func createAddress() {
        addressViewModelCreationStrategy?.strategyCompletion = { [weak self] viewModel in
            let actionHandler = LoggedInCreateAddressActionHandler()
            self?.showAddressViewController(withViewModel: viewModel,
                                            formActionHandler: actionHandler) { address in
                self?.delegate?.created(address: address)
            }
        }
        addressViewModelCreationStrategy?.execute()
    }

    func update(address: EquatableAddress) {
        let dataModel = AddressFormDataModel(equatableAddress: address, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .standardAddress : .pickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        let actionHandler = LoggedInUpdateAddressActionHandler()
        showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { [weak self] address in
            self?.delegate?.updated(address: address)
        }
    }

    func delete(address: EquatableAddress) {
        AtlasUIClient.deleteAddress(withId: address.id) { [weak self] result in
            guard let _ = result.process() else { return }
            self?.delegate?.deleted(address: address)
        }
    }

}

extension LoggedInAddressListActionHandler {

    fileprivate func showAddressViewController(withViewModel viewModel: AddressFormViewModel,
                                               formActionHandler: AddressFormActionHandler,
                                               completion: @escaping AddressFormCompletion) {

        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: formActionHandler, completion: completion)
        viewController.displayView()
    }

}
