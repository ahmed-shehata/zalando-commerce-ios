//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion? { get set }
    var navigationController: UINavigationController? { get set }

    func execute(checkout: AtlasCheckout)

}

extension AddressCreationStrategy {

    func showCreateAddress(addressType: AddressFormType, checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: addressType,
                                                       addressMode: .createAddress,
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .OverCurrentContext
        self.navigationController?.showViewController(navigationController, sender: nil)
    }

}
