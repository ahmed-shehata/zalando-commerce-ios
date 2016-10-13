//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var navigationController: UINavigationController?

    func execute(checkout: AtlasCheckout) {
        let title = Localizer.string("Address.Add.type.title")
        let standardAction = ButtonAction(text: "Address.Add.type.standard", style: .Default) { [weak self] (UIAlertAction) in
            self?.showCreateAddress(.StandardAddress, checkout: checkout)
        }
        let pickupPointAction = ButtonAction(text: "Address.Add.type.pickupPoint", style: .Default) { [weak self] (UIAlertAction) in
            self?.showCreateAddress(.PickupPoint, checkout: checkout)
        }
        let cancelAction = ButtonAction(text: "Cancel", style: .Cancel, handler: nil)

        UserMessage.show(title: title,
                         preferredStyle: .ActionSheet,
                         actions: standardAction, pickupPointAction, cancelAction)
    }

    private func showCreateAddress(addressType: AddressFormType, checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: .createAddress,
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)
        showCreateAddressViewController(viewController)
    }

}
