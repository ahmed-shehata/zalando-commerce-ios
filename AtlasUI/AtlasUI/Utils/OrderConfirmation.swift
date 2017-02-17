//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension OrderConfirmation {

    init(order: Order, selectedArticle: SelectedArticle) {
        self.orderNumber = order.orderNumber
        self.requestedSKU = selectedArticle.article.id
        self.purchasedSKU = selectedArticle.sku
        self.quantity = selectedArticle.quantity
        self.customerNumber = order.customerNumber
        self.billingAddress = order.billingAddress
        self.shippingAddress = order.shippingAddress
        self.grossTotal = order.grossTotal
        self.taxTotal = order.taxTotal
    }

    init(guestOrder: GuestOrder, selectedArticle: SelectedArticle) {
        self.orderNumber = guestOrder.orderNumber
        self.requestedSKU = selectedArticle.article.id
        self.purchasedSKU = selectedArticle.sku
        self.quantity = selectedArticle.quantity
        self.customerNumber = nil
        self.billingAddress = guestOrder.billingAddress
        self.shippingAddress = guestOrder.shippingAddress
        self.grossTotal = guestOrder.grossTotal
        self.taxTotal = guestOrder.taxTotal
    }

}
