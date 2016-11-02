//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressCreationStrategy: class {

    var addressFormCompletion: AddressFormCompletion? { get set }
    var navigationController: UINavigationController? { get set }
    var showAddressFormStrategy: ShowAddressFormStrategy? { get set }

    func execute(checkout: AtlasCheckout)

}

extension AddressCreationStrategy {

    func showCreateAddress(addressType: AddressFormType, checkout: AtlasCheckout) {
        showAddressBookAlert(addressType, checkout: checkout)
    }

    private func showAddressBookAlert(addressType: AddressFormType, checkout: AtlasCheckout) {
        showAddressFormStrategy = ShowAddressFormStrategy { type in
            switch type {
            case .newAddress:
                self.showAddressForm(addressType, addressMode: .createAddress, checkout: checkout)
            case .fromAddressBook(let address):
                self.showAddressForm(addressType, addressMode: .createAddressFromTemplate(address: address), checkout: checkout)
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
        self.navigationController?.showViewController(navigationController, sender: nil)
    }

}
