//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct SelectedArticle {

    public let article: Article
    public let unitIndex: Int
    public let quantity: Int

    public let maxQuantityAllowed: Int

    private static let minQuantityAllowed = 1
    private static let maxQuantityAllowed = 10

    public init(article: Article, desiredQuantity: Int, unitIndex: Int = 0) {
        self.article = article
        self.unitIndex = unitIndex

        if let unit = article.availableUnits[safe: unitIndex] {
            let quantityAvailable = unit.stock ?? SelectedArticle.minQuantityAllowed
            self.maxQuantityAllowed = min(quantityAvailable, SelectedArticle.maxQuantityAllowed)
            self.quantity = min(desiredQuantity, maxQuantityAllowed)
        } else {
            self.maxQuantityAllowed = SelectedArticle.minQuantityAllowed
            self.quantity = SelectedArticle.minQuantityAllowed
        }
    }

    public var sku: SimpleSKU {
        return unit?.id ?? SimpleSKU.empty
    }

    public var unit: Article.Unit? {
        return article.availableUnits[safe: unitIndex]
    }

    public var price: Money {
        return unit?.price ?? Money(amount: 0, currency: currency)
    }

    public var priceAmount: MoneyAmount {
        return unit?.price.amount ?? 0
    }

    public var totalPrice: Money {
        return Money(amount: priceAmount * quantity, currency: currency)
    }

    public var currency: Currency {
        return unit?.price.currency ?? article.availableUnits[0].price.currency
    }

    public var isSelected: Bool {
        return unitIndex != nil
    }

}

public func * (lhs: Decimal, rhs: Int) -> Decimal {
    return lhs * Decimal(rhs)
}

public func == (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id == rhs.article.id && lhs.unitIndex == rhs.unitIndex && lhs.quantity == rhs.quantity
}

public func != (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id != rhs.article.id || lhs.unitIndex != rhs.unitIndex || lhs.quantity != rhs.quantity
}
