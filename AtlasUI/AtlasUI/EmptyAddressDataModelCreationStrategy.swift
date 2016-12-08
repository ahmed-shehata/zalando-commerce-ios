//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EmptyAddressDataModelCreationStrategy: AddressDataModelCreationStrategy {

    let completion: AddressDataModelCreationStrategyCompletion

    required init(completion: @escaping AddressDataModelCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        completion(AddressFormDataModel(countryCode: AtlasAPIClient.shared?.salesChannelCountry))
    }

}

class StandardAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}

// swiftlint:disable:next type_name
class PickupPointAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}
