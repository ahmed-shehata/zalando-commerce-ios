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
    let isSelected: Bool

    var unitIndex: Int? {
        return article.availableUnits.index(of: unit)
    }

    private static let minQuantityAllowed = 1
    private static let maxQuantityAllowed = 10

    init(from selectedArticle: SelectedArticle, changeQuantity newQuantity: Int) {
        self.init(article: selectedArticle.article,
                  desiredQuantity: newQuantity,
                  selectedUnitIndex: selectedArticle.unitIndex)
    }

    init(from selectedArticle: SelectedArticle, changeSelectedIndex newIndex: Int) {
        self.init(article: selectedArticle.article,
                  desiredQuantity: selectedArticle.quantity,
                  selectedUnitIndex: newIndex)
    }

    init(article: Article, desiredQuantity: Int, selectedUnitIndex unitIndex: Int? = 0) {
        self.article = article

        let unit = article.availableUnits[safe: unitIndex] ?? Article.Unit.empty
        self.unit = unit

        let quantityAvailable = unit.stock ?? SelectedArticle.minQuantityAllowed
        self.maxQuantityAllowed = min(quantityAvailable, SelectedArticle.maxQuantityAllowed)
        self.quantity = min(desiredQuantity, maxQuantityAllowed)

        self.isSelected = article.availableUnits[safe: unitIndex] != nil
    }

    var sku: SimpleSKU {
        return unit.id
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

func * (lhs: Decimal, rhs: Int) -> Decimal {
    return lhs * Decimal(rhs)
}

func == (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id == rhs.article.id && lhs.unit == rhs.unit && lhs.quantity == rhs.quantity
}

func != (lhs: SelectedArticle, rhs: SelectedArticle) -> Bool {
    return lhs.article.id != rhs.article.id || lhs.unit != rhs.unit || lhs.quantity != rhs.quantity
}
