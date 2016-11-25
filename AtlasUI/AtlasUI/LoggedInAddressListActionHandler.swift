//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct LoggedInAddressListActionHandler: AddressListActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy?
    weak var delegate: AddressListActionHandlerDelegate?

    init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?) {
        self.addressViewModelCreationStrategy = addressViewModelCreationStrategy
    }

    func createAddress() {
        addressViewModelCreationStrategy?.setStrategyCompletion() { viewModel in
            let actionHandler = LoggedInCreateAddressActionHandler()
            self.showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { (address, _) in
                self.delegate?.addressCreated(address)
            }
        }
        addressViewModelCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress) {
        let dataModel = AddressFormDataModel(equatableAddress: address, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .standardAddress : .pickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        let actionHandler = LoggedInUpdateAddressActionHandler()
        showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { (address, _) in
            self.delegate?.addressUpdated(address)
        }
    }

    func deleteAddress(address: EquatableAddress) {
        AtlasUIClient.deleteAddress(address.id) { result in
            guard let _ = result.process() else { return }
            self.delegate?.addressDeleted(address)
        }
    }

}

extension LoggedInAddressListActionHandler {

    private func showAddressViewController(withViewModel viewModel: AddressFormViewModel,
                                                         formActionHandler: AddressFormActionHandler,
                                                         completion: AddressFormCompletion) {

        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: formActionHandler, completion: completion)
        viewController.displayView()
    }

}
