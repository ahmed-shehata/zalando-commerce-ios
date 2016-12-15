//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryDataModel {

    let selectedArticleUnit: SelectedArticleUnit
    let shippingAddress: FormattableAddress?
    let billingAddress: FormattableAddress?
    let paymentMethod: String?
    let shippingPrice: MoneyAmount
    let totalPrice: MoneyAmount
    let delivery: Delivery?
    let email: String?
    let orderNumber: String?

    init(selectedArticleUnit: SelectedArticleUnit,
         shippingAddress: FormattableAddress? = nil,
         billingAddress: FormattableAddress? = nil,
         paymentMethod: String? = nil,
         shippingPrice: MoneyAmount = 0,
         totalPrice: MoneyAmount,
         delivery: Delivery? = nil,
         email: String? = nil,
         orderNumber: String? = nil) {

        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.paymentMethod = paymentMethod
        self.shippingPrice = shippingPrice
        self.totalPrice = totalPrice
        self.delivery = delivery
        self.email = email
        self.orderNumber = orderNumber
    }

}

extension CheckoutSummaryDataModel {

    var formattedShippingAddress: [String] {
        return shippingAddress?.splittedFormattedPostalAddress ?? [Localizer.format(string: "summaryView.label.emptyAddress.shipping")]
    }

    var formattedBillingAddress: [String] {
        return billingAddress?.splittedFormattedPostalAddress ?? [Localizer.format(string: "summaryView.label.emptyAddress.billing")]
    }

    var isPaymentSelected: Bool {
        return paymentMethod != nil
    }

    var isPayPal: Bool {
        return paymentMethod?.caseInsensitiveCompare("paypal") == .orderedSame
    }

    var isAddressesReady: Bool {
        return shippingAddress != nil && billingAddress != nil
    }

    var termsAndConditionsURL: URL? {
        return AtlasAPIClient.shared?.config.salesChannel.termsAndConditionsURL
    }

}

extension CheckoutSummaryDataModel {

    init(selectedArticleUnit: SelectedArticleUnit, cartCheckout: CartCheckout?, addresses: CheckoutAddresses? = nil) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = addresses?.shippingAddress ?? cartCheckout?.checkout?.shippingAddress
        self.billingAddress = addresses?.billingAddress ?? cartCheckout?.checkout?.billingAddress
        self.paymentMethod = cartCheckout?.checkout?.payment.selected?.method?.localizedTitle
        self.shippingPrice = 0
        self.totalPrice = cartCheckout?.cart?.grossTotal.amount ?? selectedArticleUnit.priceAmount
        self.delivery = cartCheckout?.checkout?.delivery
        self.email = nil
        self.orderNumber = nil
    }

    init(selectedArticleUnit: SelectedArticleUnit, checkout: Checkout?, order: Order) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = order.shippingAddress
        self.billingAddress = order.billingAddress
        self.paymentMethod = checkout?.payment.selected?.method?.localizedTitle
        self.shippingPrice = 0
        self.totalPrice = order.grossTotal.amount
        self.delivery = checkout?.delivery
        self.email = nil
        self.orderNumber = order.orderNumber
    }

    init(selectedArticleUnit: SelectedArticleUnit, guestCheckout: GuestCheckout?, email: String, addresses: CheckoutAddresses? = nil) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = addresses?.shippingAddress ?? guestCheckout?.shippingAddress
        self.billingAddress = addresses?.billingAddress ?? guestCheckout?.billingAddress
        self.paymentMethod = guestCheckout?.payment.method.localizedTitle
        self.shippingPrice = 0
        self.totalPrice = guestCheckout?.cart.grossTotal.amount ?? selectedArticleUnit.priceAmount
        self.delivery = guestCheckout?.delivery
        self.email = email
        self.orderNumber = nil
    }

    init(selectedArticleUnit: SelectedArticleUnit, guestCheckout: GuestCheckout?, email: String, guestOrder: GuestOrder) {
        self.selectedArticleUnit = selectedArticleUnit
        self.shippingAddress = guestOrder.shippingAddress
        self.billingAddress = guestOrder.billingAddress
        self.paymentMethod = guestCheckout?.payment.method.localizedTitle
        self.shippingPrice = 0
        self.totalPrice = guestOrder.grossTotal.amount
        self.delivery = guestCheckout?.delivery
        self.email = email
        self.orderNumber = guestOrder.orderNumber
    }

}

extension PaymentMethodType {

    var localizedTitle: String {
        return Localizer.format(string: "paymentMethod.\(rawValue)")
    }

}
