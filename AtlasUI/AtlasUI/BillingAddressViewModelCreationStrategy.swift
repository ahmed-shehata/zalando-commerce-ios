//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class BillingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    var completion: AddressViewModelCreationStrategyCompletion?
    private var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

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
        showActionSheet(dataModelStrategies: availableDataModelCreationStrategies)
    }

}
