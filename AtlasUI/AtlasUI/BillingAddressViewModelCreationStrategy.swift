//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    private var titleLocalizedKey: String?
    private var completion: AddressViewModelCreationStrategyCompletion?
    private var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

    func configure(withTitle titleLocalizedKey: String?, completion: AddressViewModelCreationStrategyCompletion?) {
        self.titleLocalizedKey = titleLocalizedKey
        self.completion = completion
    }

    func execute() {
        let standardStrategy = StandardAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(addressViewModel: viewModel)
        }
        let addressBookStrategy = AddressBookImportDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(addressViewModel: viewModel)
        }

        availableDataModelCreationStrategies = [standardStrategy, addressBookStrategy]
        showActionSheet(titleLocalizedKey, strategies: availableDataModelCreationStrategies)
    }

}
