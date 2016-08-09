//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasCheckout> -> Void
public typealias CreateCheckoutCompletion = AtlasResult<CheckoutViewModel> -> Void

public struct AtlasCheckout {

    public let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    public static func configure(options: Options, completion: AtlasCheckoutConfigurationCompletion) {
        Atlas.configure(options) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let client):
                completion(.success(AtlasCheckout(client: client)))
            }
        }
    }

    public func presentCheckoutView(onViewController viewController: UIViewController? = UIApplication.topViewController(),
        sku: String) -> Bool {
            guard let viewController = viewController else {
                AtlasLogger.logError("No controller to present")
                return false
            }

            let sizeSelectionViewController = SizeSelectionViewController(checkout: self, sku: sku)

            let navigationController = UINavigationController(rootViewController: sizeSelectionViewController)
            navigationController.transitioningDelegate = CheckoutTransitioningDelegate()
            navigationController.modalPresentationStyle = .Custom

            viewController.presentViewController(navigationController, animated: true, completion: nil)

            return true
    }

    mutating func createCheckout(withArticle article: Article, articleUnitIndex: Int, completion: CreateCheckoutCompletion) {
        let articleSKU = article.units[articleUnitIndex].id
        let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

        client.createCart(cartItemRequest) { result in
            switch result {

            case .failure(let error):
                UserMessage.showError(title: "Fatal Error".loc, error: error)
                completion(.failure(error))

            case .success(let cart):
                self.client.createCheckout(cart.id) { result in
                    switch result {
                    case .failure(let error):
                        UserMessage.showError(title: "Fatal Error".loc, error: error)
                        completion(.failure(error))

                    case .success(let checkout):
                        var checkoutModel = CheckoutViewModel()
                        checkoutModel.articleUnitIndex = articleUnitIndex
                        checkoutModel.checkout = checkout
                        checkoutModel.article = article
                        checkoutModel.paymentMethodText = checkout.payment.selected?.method
                        checkoutModel.shippingAddressText = checkout.shippingAddress?.fullAddress()

                        completion(.success(checkoutModel))
                    }
                }
            }
        }
    }

}
