//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class EmptyAddressFormCreationStrategy: AddressFormCreationStrategy {

    let completion: AddressFormCreationStrategyCompletion

    required init(completion: AddressFormCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        completion(AddressFormViewModel())
    }

}

class StandardAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}

class PickupPointAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}
