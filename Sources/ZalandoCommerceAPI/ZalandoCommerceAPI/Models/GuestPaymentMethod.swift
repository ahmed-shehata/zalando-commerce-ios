//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public struct GuestPaymentMethod {

    public let method: PaymentMethodType?
    public let selectionPageURL: URL

}

extension GuestPaymentMethod: JSONInitializable {

    private struct Keys {
        static let method = "method"
        static let selectionPageURL = "selection_page_url"
    }

    init?(json: JSON) {
        guard let selectionPageURL = json[Keys.selectionPageURL].url else { return nil }
        self.init(method: PaymentMethodType(rawValue: json[Keys.method].string),
                  selectionPageURL: selectionPageURL)
    }

}
