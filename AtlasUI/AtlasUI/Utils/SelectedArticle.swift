//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct SelectedArticle {

    let article: Article
    let unit: Article.Unit
    let quantity: Int

    let maxQuantityAllowed: Int

    private static let minQuantityAllowed = 1
    private static let maxQuantityAllowed = 10

    init(changeQuantity newQuantity: Int, from selectedArticle: SelectedArticle) {
        self.init(article: selectedArticle.article,
                  desiredQuantity: newQuantity,
                  selectedUnitIndex: selectedArticle.unitIndex)
    }

    init(changeSelectedIndex newIndex: Int, from selectedArticle: SelectedArticle) {
        self.init(article: selectedArticle.article,
                  desiredQuantity: selectedArticle.quantity,
                  selectedUnitIndex: newIndex)
    }

    init(article: Article, desiredQuantity: Int = 1, selectedUnitIndex unitIndex: Int? = 0) {
        let unit = article.availableUnits[safe: unitIndex] ?? Article.Unit.empty
        self.init(article: article, desiredQuantity: desiredQuantity, unit: unit)
    }

    init(article: Article, desiredQuantity: Int = 1, unit: Article.Unit) {
        self.article = article
        self.unit = unit

        let quantityAvailable = unit.stock ?? SelectedArticle.minQuantityAllowed
        self.maxQuantityAllowed = min(quantityAvailable, SelectedArticle.maxQuantityAllowed)
        self.quantity = min(desiredQuantity, maxQuantityAllowed)
    }

    var sku: SimpleSKU {
        return unit.id
    }

    var isSelected: Bool {
        return unitIndex != nil
    }

    var unitIndex: Int? {
        return article.availableUnits.index(of: unit)
    }

    var totalPrice: Money {
        let price = unit.price
        return Money(amount: price.amount * quantity, currency: price.currency)
    }

    var totalOriginalPrice: Money {
        let originalPrice = unit.price
        return Money(amount: originalPrice.amount * quantity, currency: originalPrice.currency)
    }

}

extension SelectedArticle {

    static func withoutUnit(article: Article) -> SelectedArticle {
        return SelectedArticle(article: article, desiredQuantity: 1, unit: Article.Unit.empty)
    }

}

func * (lhs: Decimal, rhs: Int) -> Decimal {
    return lhs * Decimal(rhs)
}

func == (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id == rhs.article.id && lhs.unit == rhs.unit && lhs.quantity == rhs.quantity
}

func != (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id != rhs.article.id || lhs.unit != rhs.unit || lhs.quantity != rhs.quantity
}
