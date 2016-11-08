//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class EmptyAddressFormCreationStrategy: AddressFormCreationStrategy {

    let countryCode: String
    let completion: AddressFormCreationStrategyCompletion

    required init(countryCode: String, completion: AddressFormCreationStrategyCompletion) {
        self.countryCode = countryCode
        self.completion = completion
    }

    func execute() {
        completion(AddressFormViewModel(countryCode: countryCode))
    }

}

class StandardAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}

class PickupPointAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}
