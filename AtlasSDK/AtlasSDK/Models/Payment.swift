//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasCommons

public struct Payment {
    public let method: String?
    public let metadata: [String: AnyObject]?
    public let externalPayment: Bool?
    public let selectionPageUrl: NSURL?
}

extension Payment: JSONInitializable {

    private struct Keys {
        static let method = "method"
        static let metadata = "metadata"
        static let externalPayment = "external_payment"
        static let selectionPageUrl = "selection_page_url"
    }

    init?(json: JSON) {
        self.init(method: json[Keys.method].string,
            metadata: json[Keys.metadata].dictionaryObject,
            externalPayment: json[Keys.externalPayment].bool,
            selectionPageUrl: json[Keys.selectionPageUrl].URL)
    }

}
