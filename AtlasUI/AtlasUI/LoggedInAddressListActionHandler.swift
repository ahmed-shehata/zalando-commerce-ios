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
        addressViewModelCreationStrategy?.titleKey = "addressListView.add.type.title"
        addressViewModelCreationStrategy?.strategyCompletion = { [weak self] viewModel in
            let actionHandler = LoggedInCreateAddressActionHandler()
            self?.presentAddressViewController(with: viewModel, handler: actionHandler) { address, email in
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
        presentAddressViewController(with: viewModel, handler: actionHandler) { [weak self] address, email in
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

    fileprivate func presentAddressViewController(with viewModel: AddressFormViewModel,
                                                  handler formActionHandler: AddressFormActionHandler,
                                                  completion: @escaping AddressFormCompletion) {

        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: formActionHandler, completion: completion)
        viewController.present()
    }

}
