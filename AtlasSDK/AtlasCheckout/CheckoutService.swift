//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasCommons

public typealias GenerateCheckoutCompletion = AtlasResult<CheckoutViewModel> -> Void

public class CheckoutService {

    private var currentCart: Cart?
    private var currentCheckout: Checkout?

    private func createCart(articleSKU: String, completion: CartCompletion) {
        let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

        AtlasSDK.createCart(cartItemRequest) { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))
            case .success(let cart):
                completion(.success(cart))
            }
        }
    }

    func createCheckout(cartId: String, completion: CheckoutCompletion) {
        AtlasSDK.createCheckout(cartId, billingAddressId: nil, shippingAddressId: nil, completion: { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))
            case .success(let checkout):
                completion(.success(checkout))
            }
        })
    }

    func createOrder(checkoutId: String, completion: OrderCompletion) {
        AtlasSDK.createOrder(checkoutId, completion: { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))
            case .success(let order):
                completion(.success(order))
            }
        })
    }

    func generateCheckout(withArticle article: Article, articleUnitIndex: Int, completion: GenerateCheckoutCompletion) {
        let selectedArticle = article.units[articleUnitIndex]

        self.createCart(selectedArticle.id) { (result) in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                UserMessage.showOK(title: "Fatal Error".loc, message: String(error))
                completion(.failure(error))
            case .success(let cart):
                self.currentCart = cart
                self.createCheckout(cart.id) { result in
                    switch result {
                    case .failure(let error):
                        AtlasLogger.logError(error)
                        completion(.failure(error))
                    case .success(let checkout):
                        var checkoutObj = CheckoutViewModel()
                        checkoutObj.articleUnitIndex = articleUnitIndex
                        checkoutObj.checkout = checkout
                        checkoutObj.article = article
                        checkoutObj.paymentMethodText = "Card **** **** **** 1212"
                        checkoutObj.shippingAddressText = "John Doe, Mollstr 1, 10178 Berlin"
                        completion(.success(checkoutObj))
                    }
                }
            }
        }

    }

}
