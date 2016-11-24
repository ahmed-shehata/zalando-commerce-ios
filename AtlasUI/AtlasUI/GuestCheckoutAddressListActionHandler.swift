//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

struct GuestCheckoutAddressListActionHandler: AddressListActionHandler {

    var addressViewModelCreationStrategy: AddressViewModelCreationStrategy?
    var emailAddress: String?
    weak var delegate: AddressListActionHandlerDelegate?

    init(addressViewModelCreationStrategy: AddressViewModelCreationStrategy?) {
        self.addressViewModelCreationStrategy = addressViewModelCreationStrategy
    }

    func createAddress() {
        let actionHandler = GuestCheckoutCreateAddressActionHandler()
        addressViewModelCreationStrategy?.setStrategyCompletion() { viewModel in
            let guestViewModel = self.guestViewModel(fromViewModel: viewModel)
            self.showAddressViewController(withViewModel: guestViewModel, formActionHandler: actionHandler) { (address, email) in
                if let email = email {
                    self.delegate?.emailUpdated(email)
                }
                self.delegate?.addressCreated(address)
            }
        }
        addressViewModelCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress) {
        let actionHandler = GuestCheckoutUpdateAddressActionHandler()
        let dataModel = AddressFormDataModel(equatableAddress: address, email: emailAddress, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .guestStandardAddress : .guestPickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        showAddressViewController(withViewModel: viewModel, formActionHandler: actionHandler) { (address, email) in
            if let email = email {
                self.delegate?.emailUpdated(email)
            }
            self.delegate?.addressUpdated(address)
        }
    }

    func deleteAddress(address: EquatableAddress) {
        delegate?.addressDeleted(address)
    }

}

extension GuestCheckoutAddressListActionHandler {

    private func guestViewModel(fromViewModel viewModel: AddressFormViewModel) -> AddressFormViewModel {
        let type: AddressFormType
        switch viewModel.type {
        case .standardAddress: type = .guestStandardAddress
        case .pickupPoint: type = .guestPickupPoint
        default: type = viewModel.type
        }

        let dataModel = viewModel.dataModel
        dataModel.email = emailAddress

        return AddressFormViewModel(dataModel: dataModel, layout: viewModel.layout, type: type)
    }

}
