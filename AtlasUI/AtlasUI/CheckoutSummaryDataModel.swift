//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryDataModel {

    let selectedArticleUnit: SelectedArticleUnit
    var shippingAddress: FormattableAddress?
    var billingAddress: FormattableAddress?
    var paymentMethod: String?
    var shippingPrice: MoneyAmount?
    var totalPrice: MoneyAmount?
    var delivery: Delivery?

    init(selectedArticleUnit: SelectedArticleUnit,
         shippingAddress: FormattableAddress? = nil,
         billingAddress: FormattableAddress? = nil,
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

    var addresses: CheckoutAddresses {
        return CheckoutAddresses(billingAddress: billingAddress as? EquatableAddress, shippingAddress: shippingAddress as? EquatableAddress)
    }

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

extension CheckoutSummaryDataModel {

    init(selectedArticleUnit: SelectedArticleUnit, cart: Cart?, checkout: Checkout?) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = checkout?.shippingAddress
        self.billingAddress = checkout?.billingAddress
        self.paymentMethod = checkout?.payment.selected?.method
        self.shippingPrice = 0
        self.totalPrice = cart?.grossTotal.amount
        self.delivery = checkout?.delivery
    }

    init(selectedArticleUnit: SelectedArticleUnit, checkout: Checkout?, order: Order) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = order.shippingAddress
        self.billingAddress = order.billingAddress
        self.paymentMethod = checkout?.payment.selected?.method
        self.shippingPrice = 0
        self.totalPrice = order.grossTotal.amount
        self.delivery = checkout?.delivery
    }

}
