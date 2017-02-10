//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

// swiftlint:disable missing_docs

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
        return unit?.id ?? ""
    }

    public var unit: Article.Unit? {
        guard !notSelected, unitIndex < article.availableUnits.count else { return nil }
        return article.availableUnits[unitIndex]
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

    public var currency: String {
        return unit?.price.currency ?? article.availableUnits[0].price.currency
    }

    public var notSelected: Bool {
        return unitIndex == NSNotFound
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
