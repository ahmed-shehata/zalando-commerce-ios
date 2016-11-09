//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryDataModel {

    let selectedArticleUnit: SelectedArticleUnit
    var shippingAddress: EquatableAddress?
    var billingAddress: EquatableAddress?
    var paymentMethod: String?
    var shippingPrice: MoneyAmount?
    var totalPrice: MoneyAmount?
    var delivery: Delivery?

    init(selectedArticleUnit: SelectedArticleUnit,
         shippingAddress: EquatableAddress? = nil,
         billingAddress: EquatableAddress? = nil,
         paymentMethod: String? = nil,
         shippingPrice: MoneyAmount? = nil,
         totalPrice: MoneyAmount? = nil,
         delivery: Delivery? = nil) {

        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.paymentMethod = paymentMethod
        self.shippingPrice = shippingPrice
        self.totalPrice = totalPrice
        self.delivery = delivery
    }

}

extension CheckoutSummaryDataModel {

    var formattedShippingAddress: [String] {
        return shippingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("summaryView.label.emptyAddress.shipping")]
    }

    var formattedBillingAddress: [String] {
        return billingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("summaryView.label.emptyAddress.billing")]
    }

    var isPaymentSelected: Bool {
        return paymentMethod != nil
    }

    var isPayPal: Bool {
        return paymentMethod?.caseInsensitiveCompare("paypal") == .OrderedSame
    }

}
