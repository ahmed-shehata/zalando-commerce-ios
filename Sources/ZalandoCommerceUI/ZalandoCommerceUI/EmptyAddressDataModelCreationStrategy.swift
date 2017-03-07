//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

class EmptyAddressDataModelCreationStrategy: AddressDataModelCreationStrategy {

    let completion: AddressDataModelCreationStrategyCompletion

    required init(completion: @escaping AddressDataModelCreationStrategyCompletion) {
        self.completion = completion
    }

    func execute() {
        completion(AddressFormDataModel(countryCode: Config.shared?.salesChannel.countryCode))
    }

}

class StandardAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}

class PackstationAddressDataModelCreationStrategy: EmptyAddressDataModelCreationStrategy {}
