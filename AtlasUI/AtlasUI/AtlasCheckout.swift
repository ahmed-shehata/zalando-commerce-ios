//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasCheckout> -> Void
public typealias CreateCheckoutCompletion = AtlasResult<CheckoutViewModel> -> Void

public class AtlasCheckout: LocalizerProviderType {

    public let client: APIClient
    public let options: Options

    lazy private(set) var localizer: Localizer = Localizer(localizationProvider: self)

    init(client: APIClient, options: Options) {
        self.client = client
        self.options = options
    }

    public static func configure(options: Options, completion: AtlasCheckoutConfigurationCompletion) {
        Atlas.configure(options) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let client):
                completion(.success(AtlasCheckout(client: client, options: options)))
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
            let checkoutTransitioning = CheckoutTransitioningDelegate()
            let navigationController = UINavigationController(rootViewController: sizeSelectionViewController)
            navigationController.transitioningDelegate = checkoutTransitioning
            navigationController.modalPresentationStyle = .Custom

            viewController.presentViewController(navigationController, animated: true, completion: nil)

            return true
    }

    func createCheckout(withArticle article: Article, articleUnitIndex: Int, completion: CreateCheckoutCompletion) {
        let articleSKU = article.units[articleUnitIndex].id
        let cartItemRequest = CartItemRequest(sku: articleSKU, quantity: 1)

        client.createCart(cartItemRequest) { result in
            switch result {

            case .failure(let error):
                UserMessage.showError(title: self.loc("Fatal Error"), error: error)
                completion(.failure(error))

            case .success(let cart):
                self.client.createCheckout(cart.id) { result in
                    switch result {
                    case .failure(let error):
                        UserMessage.showError(title: self.loc("Fatal Error"), error: error)
                        completion(.failure(error))

                    case .success(let checkout):
                        let checkoutModel = CheckoutViewModel(article: article, selectedUnitIndex: articleUnitIndex, checkout: checkout)
                        completion(.success(checkoutModel))
                    }
                }
            }
        }
    }

}

extension AtlasCheckout: Localizable {

    public var localizedStringsBundle: NSBundle {
        return NSBundle(forClass: SizeSelectionViewController.self)
    }

    public var localeIdentifier: String {
        return options.interfaceLanguage
    }

}
