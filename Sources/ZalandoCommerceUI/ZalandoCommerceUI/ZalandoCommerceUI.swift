//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import ZalandoCommerceAPI

public typealias ZalandoCommerceUICheckoutCompletion = (ZalandoCommerceUI.CheckoutResult) -> Void

// TODO: document it, please...

final public class ZalandoCommerceUI {

    public enum Error: LocalizableError {
        case notPresented
    }

    /// Result that can returned after presenting the Checkout screen
    ///
    /// - orderPlaced: The user successfully placed the order
    ///                - orderConfirmation: The order confirmation object with the needed properties
    ///                - customerRequestedArticle: if not nil, then the customer is interested to view a specific product from the
    ///                                            recommended products displayed after purchasing
    ///                                            Please open the product detail page for the given SKU
    /// - userCancelled: The user cancelled the checkout process
    /// - finishedWithError: Error is displayed to the user
    ///                      - error: The displayed error
    public enum CheckoutResult {
        case orderPlaced(orderConfirmation: OrderConfirmation, customerRequestedArticle: ConfigSKU?)
        case userCancelled
        case finishedWithError(error: Swift.Error)
    }

    public let api: ZalandoCommerceAPI
    let localizer: Localizer

    private init(api: ZalandoCommerceAPI, localizer: Localizer) {
        self.api = api
        self.localizer = localizer
    }

    public static func configure(options: Options? = nil, completion: @escaping ResultCompletion<ZalandoCommerceUI>) {
        ZalandoCommerceAPI.configure(options: options) { result in
            switch result {
            case .failure(let error):
                Logger.error(error)
                completion(.failure(error))

            case .success(let api):
                do {
                    let localeIdentifier = api.config.interfaceLocale.identifier
                    let localizer = try Localizer(localeIdentifier: localeIdentifier)
                    let shared = ZalandoCommerceUI(api: api, localizer: localizer)
                    completion(.success(shared))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController,
                                for sku: ConfigSKU,
                                completion: @escaping ZalandoCommerceUICheckoutCompletion) {

        let commerceUIViewController = ZalandoCommerceUIViewController(forSKU: sku, uiInstance: self, completion: completion)

        let checkoutTransitioning = CheckoutTransitioningDelegate()
        commerceUIViewController.transitioningDelegate = checkoutTransitioning
        commerceUIViewController.modalPresentationStyle = .custom

        viewController.present(commerceUIViewController, animated: true, completion: nil)
    }

}

extension ZalandoCommerceAPI {

    static var shared: ZalandoCommerceAPI? {
        return try? ZalandoCommerceUI.fromPresented().api
    }

}

extension ZalandoCommerceUI {

    static func fromPresented() throws -> ZalandoCommerceUI {
        guard let controller = ZalandoCommerceUIViewController.presented else { throw Error.notPresented }
        return controller.uiInstance
    }

}

extension Config {

    static var shared: Config? {
        return ZalandoCommerceAPI.shared?.config
    }

}
