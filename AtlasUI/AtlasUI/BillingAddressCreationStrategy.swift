//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var navigationController: UINavigationController?

    func execute(checkout: AtlasCheckout) {
        let viewController = AddressFormViewController(addressType: .standardAddress,
                                                       addressMode: .createAddress,
                                                       checkout: checkout,
                                                       completion: addressFormCompletion)
        showCreateAddressViewController(viewController)
    }

}
