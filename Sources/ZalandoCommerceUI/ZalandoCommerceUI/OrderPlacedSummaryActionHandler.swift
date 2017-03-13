//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI

class OrderPlacedSummaryActionHandler: CheckoutSummaryActionHandler {

    weak var dataSource: CheckoutSummaryActionHandlerDataSource?
    weak var delegate: CheckoutSummaryActionHandlerDelegate?

    func handleSubmit() {
        try? ZalandoCommerceUIViewController.presented?.dismissCheckoutUI()
    }

    func handlePaymentSelection() {
        // Show Payment screen should have no action in Order placed mode
    }

    func handleShippingAddressSelection() {
        // Show Shipping Address screen should have no action in Order placed mode
    }

    func handleBillingAddressSelection() {
        // Show Billing Address screen should have no action in Order placed mode
    }

    func handleCouponChanges(coupon: String?) {
        // Coupon should have no action in Order placed mode
    }

    func updated(selectedArticle: SelectedArticle) {
        // Selected Article should not be updated in Order placed mode
    }

}
