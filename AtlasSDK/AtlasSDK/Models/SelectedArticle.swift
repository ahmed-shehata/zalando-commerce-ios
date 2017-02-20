//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe index: Index?) -> Element? {
        get {
            guard let index = index, (0..<count).contains(index) else { return nil }
            return self[index]
        }
    }

}

public struct SelectedArticle {

    public let article: Article
    public let unitIndex: Int?
    public let quantity: Int

    public let maxQuantityAllowed: Int

    private static let minQuantityAllowed = 1
    private static let maxQuantityAllowed = 10

    public init(article: Article, unitIndex: Int? = nil, desiredQuantity: Int) {
        self.article = article
        self.unitIndex = unitIndex

        if let unit = article.availableUnits[safe: unitIndex] {
            self.maxQuantityAllowed = min(unit.stock ?? SelectedArticle.minQuantityAllowed, SelectedArticle.maxQuantityAllowed)
            self.quantity = min(desiredQuantity, maxQuantityAllowed)
        } else {
            self.maxQuantityAllowed = SelectedArticle.minQuantityAllowed
            self.quantity = self.maxQuantityAllowed
        }
    }

    public var sku: VariantSKU {
        return unit?.id ?? ""
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
