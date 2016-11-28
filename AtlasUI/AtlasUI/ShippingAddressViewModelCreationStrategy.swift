//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressViewModelCreationStrategy: AddressViewModelCreationStrategy {

    private var titleLocalizedKey: String?
    private var completion: AddressViewModelCreationStrategyCompletion?
    private var availableDataModelCreationStrategies = [AddressDataModelCreationStrategy]()

    func configure(withTitle titleLocalizedKey: String, completion: AddressViewModelCreationStrategyCompletion?) {
        self.titleLocalizedKey = titleLocalizedKey
        self.completion = completion
    }

    func execute() {
        let standardStrategy = StandardAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(addressViewModel: viewModel)
        }
        let pickupPointStrategy = PickupPointAddressDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .pickupPoint)
            self?.completion?(addressViewModel: viewModel)
        }
        let addressBookStrategy = AddressBookImportDataModelCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.completion?(addressViewModel: viewModel)
        }

        availableDataModelCreationStrategies = [standardStrategy, pickupPointStrategy, addressBookStrategy]
        showActionSheet(titleLocalizedKey, strategies: availableDataModelCreationStrategies)
    }

}
