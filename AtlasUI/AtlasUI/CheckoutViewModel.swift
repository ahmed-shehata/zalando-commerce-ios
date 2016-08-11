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
    public let totalPrice: Article.Price?
    public let checkout: Checkout?

    public private(set) var selectedUnit: Article.Unit?
    public let selectedUnitIndex: Int?

    public var article: Article? {
        didSet {
            if let index = selectedUnitIndex {
                selectedUnit = article?.units[index]
            }
        }
    }

    public var hasArticle: Bool {
        return article != nil
    }

    init(article: Article, selectedUnitIndex: Int? = nil, shippingPrice: Article.Price? = nil, checkout: Checkout? = nil,
        shippingAddressText: String? = nil, paymentMethodText: String? = nil, discountText: String? = nil) {
            self.article = article
            self.shippingPrice = shippingPrice
            self.checkout = checkout

            self.shippingAddressText = shippingAddressText ?? checkout?.shippingAddress?.fullAddress()
            self.paymentMethodText = paymentMethodText ?? checkout?.payment.selected?.method
            self.discountText = discountText

            if let unitIndex = selectedUnitIndex {
                self.selectedUnitIndex = unitIndex
                self.selectedUnit = self.article?.units[unitIndex]
                self.totalPrice = self.article?.units[unitIndex].price
            } else {
                self.totalPrice = nil
                self.selectedUnitIndex = nil
            }
    }

}
