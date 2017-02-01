//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct SelectedArticle {

    public let article: Article
    public let unitIndex: Int
    public let quantity: Int

    public init(article: Article, unitIndex: Int, quantity: Int) {
        self.article = article
        self.unitIndex = unitIndex
        self.quantity = quantity
    }

    public var sku: String {
        return unit.id
    }

    public var unit: Article.Unit {
        return article.availableUnits[unitIndex]
    }

    public var price: Money {
        return unit.price
    }

    public var priceAmount: MoneyAmount {
        return unit.price.amount
    }

    public var totalPrice: Money {
        return Money(amount: unit.price.amount * Decimal(quantity), currency: unit.price.currency)
    }

}

public func == (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id == rhs.article.id && lhs.unitIndex == rhs.unitIndex && lhs.quantity == rhs.quantity
}

public func != (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id != rhs.article.id || lhs.unitIndex != rhs.unitIndex || lhs.quantity != rhs.quantity
}
