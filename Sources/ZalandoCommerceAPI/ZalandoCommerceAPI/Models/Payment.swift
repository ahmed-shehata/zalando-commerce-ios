//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct Payment {

    public let selected: PaymentMethod?
    public let selectionPageURL: URL

}

extension Payment: JSONInitializable {

    fileprivate struct Keys {
        static let selected = "selected"
        static let selectionPageURL = "selection_page_url"
    }

    init?(json: JSON) {
        guard let selectionPageURL = json[Keys.selectionPageURL].url else { return nil }
        self.init(selected: PaymentMethod(json: json[Keys.selected]),
                  selectionPageURL: selectionPageURL)
    }

}
