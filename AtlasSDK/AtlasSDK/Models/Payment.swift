//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

public struct Payment {

    public let selected: PaymentMethod?
    public let externalPayment: Bool?
    public let selectionPageUrl: NSURL?
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
