//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

class EmptyAddressDataModelCreationStrategy: AddressDataModelCreationStrategy {

    let completion: AddressDataModelCreationStrategyCompletion

    required init(completion: @escaping AddressDataModelCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        completion(AddressFormDataModel(countryCode: AtlasAPIClient.shared?.config.salesChannel.countryCode))
    }

}

class StandardAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}

class PackstationAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}
