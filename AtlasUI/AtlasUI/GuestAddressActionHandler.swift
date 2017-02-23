//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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
            let viewController = AddressFormViewController(viewModel: guestViewModel, actionHandler: actionHandler) { address, email in
                self.emailAddress = email
                completion(address)
            }
            viewController.present()
        }
        addressCreationStrategy?.execute()
    }

    func updateAddress(address: EquatableAddress, completion: @escaping GuestAddressActionHandlerCompletion) {
        let actionHandler = GuestCheckoutUpdateAddressActionHandler()
        let dataModel = AddressFormDataModel(equatableAddress: address,
                                             email: emailAddress,
                                             countryCode: AtlasAPI.shared?.config.salesChannel.countryCode)
        let formLayout = UpdateAddressFormLayout()
        let addressType: AddressFormType = address.isBillingAllowed ? .guestStandardAddress : .guestPickupPoint
        let viewModel = AddressFormViewModel(dataModel: dataModel, layout: formLayout, type: addressType)
        let viewController = AddressFormViewController(viewModel: viewModel, actionHandler: actionHandler) { (address, email) in
            self.emailAddress = email
            completion(address)
        }
        viewController.present()
    }

    func handleAddressModification(address: EquatableAddress?, completion: @escaping GuestAddressActionHandlerCompletion) {
        guard let address = address else {
            createAddress(completion: completion)
            return
        }

        let createAction = ButtonAction(text: Localizer.format(string: "guestSummaryView.address.create")) { [weak self] _ in
            self?.createAddress(completion: completion)
        }
        let updateAction = ButtonAction(text: Localizer.format(string: "guestSummaryView.address.update")) { [weak self] _ in
            self?.updateAddress(address: address, completion: completion)
        }
        let cancelAction = ButtonAction(text: Localizer.format(string: "button.general.cancel"), style: .cancel, handler: nil)
        UserMessage.display(actions: [createAction, updateAction, cancelAction])
    }

}

extension GuestAddressActionHandler {

    fileprivate func guestViewModel(fromViewModel viewModel: AddressFormViewModel) -> AddressFormViewModel {
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
