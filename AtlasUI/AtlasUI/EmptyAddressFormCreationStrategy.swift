//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EmptyAddressFormCreationStrategy: AddressFormCreationStrategy {

    let completion: AddressFormCreationStrategyCompletion

    required init(completion: AddressFormCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        completion(AddressFormViewModel(countryCode: AtlasAPIClient.countryCode))
    }

}

class StandardAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}

class PickupPointAddressFormCreationStrategy: EmptyAddressFormCreationStrategy {}
