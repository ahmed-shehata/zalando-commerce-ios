//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion? { get set }
    var availableTypes: [AddressCreationType] { get }

    func execute(checkout: AtlasCheckout)

}

extension AddressCreationStrategy {

    func execute(checkout: AtlasCheckout) {
        showActionSheet(availableTypes, checkout: checkout)
    }

    func showActionSheet(types: [AddressCreationType], checkout: AtlasCheckout) {
        let title = Localizer.string("addressListView.add.type.title")

        var buttonActions = types.map { type in
            ButtonAction(text: type.localizedTitleKey) { (UIAlertAction) in
                switch type {
                case .standard:
                    self.showAddressForm(.standardAddress, addressMode: .createAddress, checkout: checkout)
                case .pickupPoint:
                    self.showAddressForm(.pickupPoint, addressMode: .createAddress, checkout: checkout)
                case .addressBookImport(let strategy):
                    strategy.configure(checkout, addressCreationStrategy: self)
                    strategy.execute()
                }
            }
        }

        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

    func showAddressForm(addressType: AddressFormType, addressMode: AddressFormMode, checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: addressMode,
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        AtlasUIViewController.instance?.showViewController(navigationController, sender: nil)
    }

}

private extension ImportAddressBookStrategy {

    func configure(checkout: AtlasCheckout, addressCreationStrategy: AddressCreationStrategy) {
        completion = { contactProperty in
            let countryCode = checkout.client.config.salesChannel.countryCode
            if let addressViewModel = AddressFormViewModel(contactProperty: contactProperty, countryCode: countryCode) {
                let addressMode = AddressFormMode.createAddressFromTemplate(addressViewModel: addressViewModel)
                addressCreationStrategy.showAddressForm(.standardAddress, addressMode: addressMode, checkout: checkout)
            } else {
                UserMessage.displayError(AtlasCheckoutError.unclassified)
            }
        }
    }

}
