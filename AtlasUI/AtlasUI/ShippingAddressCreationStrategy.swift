//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var navigationController: UINavigationController?

    func execute(checkout: AtlasCheckout) {
        let title = Localizer.string("addressListView.add.type.title")
        let standardAction = ButtonAction(text: "addressListView.add.type.standard", style: .Default) { [weak self] (UIAlertAction) in
            self?.showCreateAddress(.standardAddress, checkout: checkout)
        }
        let pickupPointAction = ButtonAction(text: "addressListView.add.type.pickupPoint", style: .Default) { [weak self] (UIAlertAction) in
            self?.showCreateAddress(.pickupPoint, checkout: checkout)
        }
        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)

        UserMessage.showActionSheet(title: title, actions: standardAction, pickupPointAction, cancelAction)
    }

}
