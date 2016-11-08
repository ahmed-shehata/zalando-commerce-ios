//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion? { get set }

    func execute(checkout: AtlasCheckout)

}

extension AddressCreationStrategy {

    func showActionSheet(strategies: [AddressFormCreationStrategy], checkout: AtlasCheckout) {
        let title = Localizer.string("addressListView.add.type.title")

        var buttonActions = strategies.map { strategy in
            ButtonAction(text: strategy.localizedTitleKey) { (UIAlertAction) in
                strategy.execute()
            }
        }

        let cancelAction = ButtonAction(text: Localizer.string("button.general.cancel"), style: .Cancel, handler: nil)
        buttonActions.append(cancelAction)

        UserMessage.showActionSheet(title: title, actions: buttonActions)
    }

    func showAddressForm(addressType: AddressFormType, addressViewModel: AddressFormViewModel, checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: .createAddress(addressViewModel: addressViewModel),
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        AtlasUIViewController.instance?.showViewController(navigationController, sender: nil)
    }

}
