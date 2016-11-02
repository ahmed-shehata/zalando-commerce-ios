//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressCreationStrategy: class {

    var addressFormCompletion: AddressFormCompletion? { get set }
    var showAddressFormStrategy: ShowAddressFormStrategy? { get set }

    func execute(checkout: AtlasCheckout)

}

extension AddressCreationStrategy {

    func showCreateAddress(addressType: AddressFormType, checkout: AtlasCheckout) {
        showAddressBookAlert(addressType, checkout: checkout)
    }

    private func showAddressBookAlert(addressType: AddressFormType, checkout: AtlasCheckout) {
        showAddressFormStrategy = ShowAddressFormStrategy(countryCode: checkout.client.config.salesChannel.countryCode) { type in
            switch type {
            case .newAddress:
                self.showAddressForm(addressType, addressMode: .createAddress, checkout: checkout)
            case .fromAddressBook(let addressViewModel):
                let addressMode = AddressFormMode.createAddressFromTemplate(addressViewModel: addressViewModel)
                self.showAddressForm(addressType, addressMode: addressMode, checkout: checkout)
            }
        }
        showAddressFormStrategy?.execute()
    }

    private func showAddressForm(addressType: AddressFormType, addressMode: AddressFormMode, checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: addressMode,
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        AtlasUIViewController.instance?.showViewController(navigationController, sender: nil)
    }

}
