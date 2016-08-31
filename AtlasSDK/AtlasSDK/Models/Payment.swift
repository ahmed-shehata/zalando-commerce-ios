//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct Payment {

    public let selected: PaymentMethod?
    public let externalPayment: Bool?
    public let selectionPageUrl: NSURL?

    init(selected: PaymentMethod? = nil, externalPayment: Bool? = nil, selectionPageUrl: NSURL? = nil) {
        self.selected = selected
        self.externalPayment = externalPayment
        self.selectionPageUrl = selectionPageUrl
    }

}

extension Payment: JSONInitializable {

    private struct Keys {
        static let externalPayment = "external_payment"
        static let selected = "selected"
        static let selectionPageUrl = "selection_page_url"
    }

    init?(json: JSON) {
        self.init(selected: PaymentMethod(json: json[Keys.selected]),
            externalPayment: json[Keys.externalPayment].bool,
            selectionPageUrl: json[Keys.selectionPageUrl].URL)
    }

}
