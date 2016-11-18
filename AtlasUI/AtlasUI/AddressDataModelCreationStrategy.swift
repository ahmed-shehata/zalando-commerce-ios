//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias AddressDataModelCreationStrategyCompletion = (AddressFormDataModel) -> Void

protocol AddressDataModelCreationStrategy {

    var localizedTitleKey: String { get }

    init(completion: AddressDataModelCreationStrategyCompletion)
    func execute()

}

extension AddressDataModelCreationStrategy {

    var localizedTitleKey: String {
        return "addressListView.add.type.\(self.dynamicType)"
    }

}
