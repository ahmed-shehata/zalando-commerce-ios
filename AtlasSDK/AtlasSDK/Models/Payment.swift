//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct Payment {

    public let selected: PaymentMethod?
    public let isExternalPayment: Bool?
    public let selectionPageURL: URL?

    init(selected: PaymentMethod? = nil, isExternalPayment: Bool? = nil, selectionPageURL: URL? = nil) {
        self.selected = selected
        self.isExternalPayment = isExternalPayment
        self.selectionPageURL = selectionPageURL
    }

}

extension Payment: JSONInitializable {

    fileprivate struct Keys {
        static let externalPayment = "external_payment"
        static let selected = "selected"
        static let selectionPageURL = "selection_page_url"
    }

    init?(json: JSON) {
        self.init(selected: PaymentMethod(json: json[Keys.selected]),
                  isExternalPayment: json[Keys.externalPayment].bool,
                  selectionPageURL: json[Keys.selectionPageURL].URL)
    }

}
