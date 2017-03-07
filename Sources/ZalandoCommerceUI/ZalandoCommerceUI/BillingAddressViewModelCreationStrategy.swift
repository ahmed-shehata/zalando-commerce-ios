//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    var titleKey: String?
    var strategyCompletion: AddressViewModelCreationStrategyCompletion?
    private var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

    func execute() {
        let standardStrategy = StandardAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.strategyCompletion?(viewModel)
        }
        let addressBookStrategy = AddressBookImportDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.strategyCompletion?(viewModel)
        }

        availableDataModelCreationStrategies = [standardStrategy, addressBookStrategy]
        presentSelection(forStrategies: availableDataModelCreationStrategies)
    }

}
