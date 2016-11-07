//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias AddressFormCreationStrategyCompletion = (AddressFormViewModel) -> Void

protocol AddressFormCreationStrategy {

    var localizedTitleKey: String { get }
    var completion: AddressFormCreationStrategyCompletion { get }

    init(countryCode: String, completion: AddressFormCreationStrategyCompletion)
    func execute()
}


extension AddressFormCreationStrategy {

    var localizedTitleKey: String {
        return "addressListView.add.type.\(self.dynamicType)"
    }

}
