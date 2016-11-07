//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutViewModel {

    let selectedArticleUnit: SelectedArticleUnit
    let shippingPrice: Money?
    var cart: Cart?
    var checkout: Checkout?
    internal(set) var customer: Customer?

    var selectedBillingAddress: EquatableAddress?
    var selectedShippingAddress: EquatableAddress?

    var selectedAddresses: CheckoutAddresses {
        return (billingAddress: selectedBillingAddress, shippingAddress: selectedShippingAddress)
    }

    init(selectedArticleUnit: SelectedArticleUnit,
        shippingPrice: Money? = nil,
        cart: Cart? = nil,
        checkout: Checkout? = nil,
        customer: Customer? = nil,
        billingAddress: EquatableAddress? = nil,
        shippingAddress: EquatableAddress? = nil) {
            self.selectedArticleUnit = selectedArticleUnit
            self.shippingPrice = shippingPrice
            self.cart = cart
            self.checkout = checkout
            self.customer = customer
            self.selectedBillingAddress = checkout?.billingAddress
            self.selectedShippingAddress = checkout?.shippingAddress
    }

}

extension CheckoutViewModel {

    var shippingAddress: [String] {
        return selectedShippingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("summaryView.label.emptyAddress.shipping")]
    }

    var billingAddress: [String] {
        return selectedBillingAddress?.splittedFormattedPostalAddress ?? [Localizer.string("summaryView.label.emptyAddress.billing")]
    }

    var isPaymentSelected: Bool {
        return customer != nil && selectedPaymentMethod != nil
    }

    var shippingPriceValue: MoneyAmount {
        return shippingPrice?.amount ?? 0
    }

    var totalPriceValue: MoneyAmount {
        return cart?.grossTotal.amount ?? 0
    }

    var selectedPaymentMethod: String? {
        return checkout?.payment.selected?.method
    }

    var checkoutViewState: CheckoutViewState {
        if customer == nil {
            return .NotLoggedIn
        } else if checkout?.payment.selected?.method == nil {
            return .CheckoutIncomplete
        } else {
            return .CheckoutReady
        }
    }

    var isReadyToCreateCheckout: Bool {
        return self.checkout == nil && self.selectedBillingAddress != nil && self.selectedShippingAddress != nil
    }

}

extension CheckoutViewModel {

    mutating func addressUpdated(address: EquatableAddress) {
        if let billingAddress = selectedBillingAddress where  billingAddress == address {
            selectedBillingAddress = address
        }
        if let shippingAddress = selectedShippingAddress where  shippingAddress == address {
            selectedShippingAddress = address
        }
    }

    mutating func addressDeleted(address: EquatableAddress) {
        if let billingAddress = selectedBillingAddress where  billingAddress == address {
            selectedBillingAddress = nil
            checkout = nil
        }
        if let shippingAddress = selectedShippingAddress where  shippingAddress == address {
            selectedShippingAddress = nil
            checkout = nil
        }
    }

}

extension CheckoutViewModel {

    func validateAgainstOldViewModel(oldViewModel: CheckoutViewModel) {
        checkPriceChange(oldViewModel)
        checkPaymentMethod(oldViewModel)
    }

    private func checkPriceChange(oldViewModel: CheckoutViewModel) {
        guard let
            oldPrice = oldViewModel.cart?.grossTotal.amount,
            newPrice = cart?.grossTotal.amount else { return }

        if oldPrice != newPrice {
            UserMessage.displayError(AtlasCheckoutError.priceChanged(newPrice: newPrice))
        }
    }

    private func checkPaymentMethod(oldViewModel: CheckoutViewModel) {
        guard oldViewModel.checkout?.payment.selected?.method != nil
            && checkout?.payment.selected?.method == nil else { return }

        UserMessage.displayError(AtlasCheckoutError.paymentMethodNotAvailable)
    }

}
