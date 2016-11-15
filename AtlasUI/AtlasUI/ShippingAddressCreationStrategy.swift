//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var availableFormCreationStrategies = [AddressFormCreationStrategy]()

    func execute() {
        let standardStrategy = StandardAddressFormCreationStrategy { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel)
        }
        let pickupPointStrategy = PickupPointAddressFormCreationStrategy { [weak self] viewModel in
            self?.showAddressForm(.pickupPoint, addressViewModel: viewModel)
        }
        let addressBookStrategy = AddressBookImportCreationStrategy { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel)
        }

        availableFormCreationStrategies = [standardStrategy, pickupPointStrategy, addressBookStrategy]
        showActionSheet(strategies: availableFormCreationStrategies)
    }

}
