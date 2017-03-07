//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

protocol AddressDataModelCreationStrategy {

    var localizedTitleKey: String { get }

    init(completion: @escaping AddressDataModelCreationStrategyCompletion)
    func execute()

}

extension AddressDataModelCreationStrategy {

    var localizedTitleKey: String {
        return "addressListView.add.type.\(type(of: self))"
    }

}
