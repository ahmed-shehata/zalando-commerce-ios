//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    fileprivate var completion: AddressViewModelCreationStrategyCompletion?
    fileprivate var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

    func setStrategyCompletion(_ completion: AddressViewModelCreationStrategyCompletion?) {
        self.completion = completion
    }

    func execute() {
        let standardStrategy = StandardAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(viewModel)
        }
        let addressBookStrategy = AddressBookImportDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(viewModel)
        }

        availableDataModelCreationStrategies = [standardStrategy, addressBookStrategy]
        showActionSheet(dataModelStrategies: availableDataModelCreationStrategies)
    }

}
