//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var availableFormCreationStrategies = [AddressFormCreationStrategy]()

    func execute(checkout: AtlasUI) {
        let countryCode = checkout.client.config.salesChannel.countryCode

        let standardStrategy = StandardAddressFormCreationStrategy(countryCode: countryCode) { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel, checkout: checkout)
        }
        let pickupPointStrategy = PickupPointAddressFormCreationStrategy(countryCode: countryCode) { [weak self] viewModel in
            self?.showAddressForm(.pickupPoint, addressViewModel: viewModel, checkout: checkout)
        }
        let addressBookStrategy = AddressBookImportCreationStrategy(countryCode: countryCode) { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel, checkout: checkout)
        }

        availableFormCreationStrategies = [standardStrategy, pickupPointStrategy, addressBookStrategy]
        showActionSheet(availableFormCreationStrategies, checkout: checkout)
    }

}
