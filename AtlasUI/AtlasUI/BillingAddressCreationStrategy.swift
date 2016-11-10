//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormCompletion: AddressFormCompletion?
    var availableFormCreationStrategies = [AddressFormCreationStrategy]()

    func execute() {
        let standardStrategy = StandardAddressFormCreationStrategy { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel)
        }

        let addressBookStrategy = AddressBookImportCreationStrategy { [weak self] viewModel in
            self?.showAddressForm(.standardAddress, addressViewModel: viewModel)
        }

        availableFormCreationStrategies = [standardStrategy, addressBookStrategy]
        showActionSheet(availableFormCreationStrategies)
    }

}
