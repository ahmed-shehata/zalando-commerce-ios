//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let shippingAddress: ShippingAddress?
    let paymentMethodText: String?
    let discountText: String?
    let shippingPrice: Article.Price?
    let checkout: Checkout?

    internal(set) var customer: Customer?

    let selectedUnitIndex: Int

    let article: Article

    init(article: Article, selectedUnitIndex: Int = 0, shippingPrice: Article.Price? = nil,
        checkout: Checkout? = nil, customer: Customer? = nil,
        paymentMethodText: String? = nil, discountText: String? = nil) {
            self.article = article
            self.shippingPrice = shippingPrice
            self.checkout = checkout
            self.customer = customer

            self.shippingAddress = checkout?.shippingAddress
            self.paymentMethodText = paymentMethodText ?? checkout?.payment.selected?.method
            self.discountText = discountText

            self.selectedUnitIndex = selectedUnitIndex
    }

}

extension CheckoutViewModel {

    func shippingAddress(formattedWith localizer: LocalizerProviderType) -> String {
        return shippingAddress?.fullAddress() ?? localizer.loc("No Shipping Address")
    }

    var isPaymentSelected: Bool {
        return customer != nil && checkout?.payment.selected?.method != nil
    }

    var selectedUnit: Article.Unit {
        return self.article.units[selectedUnitIndex]
    }

}
