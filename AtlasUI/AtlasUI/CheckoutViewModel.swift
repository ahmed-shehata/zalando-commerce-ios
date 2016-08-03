//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
public struct CheckoutViewModel {

    public var shippingAddressText: String?
    public var paymentMethodText: String?
    public var discountText: String?
    public var shippingPrice: Article.Price?
    public var totalPrice: Article.Price?
    public var articleUnitIndex: Int?
    public var checkout: Checkout?
    public var articleUnit: Article.Unit?
    public var article: Article? {
        didSet {
            if let index = articleUnitIndex {
                articleUnit = article?.units[index]
            }

        }
    }

}
