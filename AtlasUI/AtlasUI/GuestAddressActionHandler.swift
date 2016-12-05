//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

typealias GuestAddressActionHandlerCompletion = (_ address: EquatableAddress) -> Void

class GuestAddressActionHandler {

    var addressCreationStrategy: AddressViewModelCreationStrategy?
    var emailAddress: String?

    func createAddress(completion: @escaping GuestAddressActionHandlerCompletion) {
        addressCreationStrategy?.titleKey = "guestSummaryView.address.add"
        addressCreationStrategy?.strategyCompletion = { viewModel in
            let guestViewModel = self.guestViewModel(fromViewModel: viewModel)
            let actionHandler = GuestCheckoutCreateAddressActionHandler()
            let viewController = AddressFormViewController(viewModel: guestViewModel, actionHandler: actionHandler) { (address, email) in
                self.emailAddress = email
                completion(address: address)
            }
            viewController.displayView()
        }
        addressCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress, completion: @escaping GuestAddressActionHandlerCompletion) {
        let actionHandler = GuestCheckoutUpdateAddressActionHandler()
        let dataModel = AddressFormDataModel(equatableAddress: address, email: emailAddress, countryCode: AtlasAPIClient.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.pickupPoint == nil ? .guestStandardAddress : .guestPickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler) { (address, email) in
            self.emailAddress = email
            completion(address: address)
        }
        viewController.displayView()
    }

    func handleAddressModification(address: EquatableAddress?, completion: GuestAddressActionHandlerCompletion) {
        guard let address = address else {
            createAddress(completion: completion)
            return
        }

        let createAction = ButtonAction(text: Localizer.string("guestSummaryView.address.create")) { [weak self] _ in
            self?.createAddress(completion)
        }
        let updateAction = ButtonAction(text: Localizer.string("guestSummaryView.address.update")) { [weak self] _ in
            self?.updateAddress(address, completion: completion)
        }
        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)
        UserMessage.showActionSheet(title: nil, actions: [createAction, updateAction, cancelAction])
    }

    func checkoutAddresses(shippingAddress: EquatableAddress?, billingAddress: EquatableAddress?) -> CheckoutAddresses {
        let standardShippingAddress = shippingAddress?.isPickupPoint == true ? nil : shippingAddress
        return CheckoutAddresses(billingAddress: billingAddress ?? standardShippingAddress,
                                 shippingAddress: shippingAddress ?? billingAddress)
    }

}

extension GuestAddressActionHandler {

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
