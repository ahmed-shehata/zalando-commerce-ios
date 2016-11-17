//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class ShippingAddressCreationStrategy: AddressCreationStrategy {

    var addressFormActionHandler: AddressFormActionHandler?
    var availableFormCreationStrategies = [AddressFormCreationStrategy]()

    func execute() {
        let standardStrategy = StandardAddressFormCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.showAddressForm(viewModel)
        }
        let pickupPointStrategy = PickupPointAddressFormCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .pickupPoint)
            self?.showAddressForm(viewModel)
        }
        let addressBookStrategy = AddressBookImportCreationStrategy { [weak self] dataModel in
            let viewModel = AddressFormViewModel(dataModel: dataModel, layout: CreateAddressFormLayout(), type: .standardAddress)
            self?.showAddressForm(viewModel)
        }

        availableFormCreationStrategies = [standardStrategy, pickupPointStrategy, addressBookStrategy]
        showActionSheet(strategies: availableFormCreationStrategies)
    }

}
