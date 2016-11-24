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
        let actionHandler = LoggedInCreateAddressActionHandler()
        addressViewModelCreationStrategy?.setStrategyCompletion() { viewModel in
            self.showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { (address, _) in
                self.delegate?.addressCreated(address)
            }
        }
        addressViewModelCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress) {
        let actionHandler = LoggedInUpdateAddressActionHandler()
        let dataModel = AddressFormDataModel(equatableAddress: address, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .standardAddress : .pickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
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
