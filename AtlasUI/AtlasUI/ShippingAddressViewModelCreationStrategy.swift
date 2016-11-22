//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    var strategyCompletion: AddressViewModelCreationStrategyCompletion?

    fileprivate var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

    func execute() {
        let standardStrategy = StandardAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.strategyCompletion?(viewModel)
        }
        let pickupPointStrategy = PickupPointAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .pickupPoint)
            self?.strategyCompletion?(viewModel)
        }
        let addressBookStrategy = AddressBookImportDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.strategyCompletion?(viewModel)
        }

        availableDataModelCreationStrategies = [standardStrategy, pickupPointStrategy, addressBookStrategy]
        showActionSheet(dataModelStrategies: availableDataModelCreationStrategies)
    }

}
