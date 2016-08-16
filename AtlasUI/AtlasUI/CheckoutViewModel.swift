//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public struct CheckoutViewModel {

    public let shippingAddressText: String?
    public let paymentMethodText: String?
    public let discountText: String?
    public let shippingPrice: Article.Price?
    public let checkout: Checkout?

    public internal(set) var customer: Customer?

    public let selectedUnitIndex: Int

    public let article: Article

    public var isPaymentSelected: Bool {
        return customer != nil && checkout?.payment.selected?.method != nil
    }

    public var selectedUnit: Article.Unit {
        return article.units[selectedUnitIndex]
    }

    public var unitPrice: Article.Price {
        return self.article.units[selectedUnitIndex].price
    }

    init(article: Article, selectedUnitIndex: Int = 0, shippingPrice: Article.Price? = nil,
        checkout: Checkout? = nil, customer: Customer? = nil,
        shippingAddressText: String? = nil, paymentMethodText: String? = nil, discountText: String? = nil) {
            self.article = article
            self.shippingPrice = shippingPrice
            self.checkout = checkout
            self.customer = customer

            self.shippingAddressText = shippingAddressText ?? checkout?.shippingAddress?.fullAddress()
            self.paymentMethodText = paymentMethodText ?? checkout?.payment.selected?.method
            self.discountText = discountText

            self.selectedUnitIndex = selectedUnitIndex
    }

}
