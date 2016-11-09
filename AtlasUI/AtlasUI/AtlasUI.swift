//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasUI> -> Void

typealias CreateCheckoutViewModelCompletion = AtlasResult<CheckoutViewModel> -> Void

final public class AtlasUI {

    public let client: AtlasAPIClient
    private static let injector = Injector()

    private init(client: AtlasAPIClient) {
        self.client = client
    }

    /**
     Configure AtlasCheckout.

     - Parameters:
        - options `Options`: provide an `Options` instance with at least 2 mandatory parameters **clientId** and **salesChannel**
            options could be nil, then Info.plist configuration would be used:
             - ATLASSDK_CLIENT_ID: String - Client Id (required)
             - ATLASSDK_SALES_CHANNEL: String - Sales Channel (required)
             - ATLASSDK_USE_SANDBOX: Bool - Indicates whether sandbox environment should be used
             - ATLASSDK_INTERFACE_LANGUAGE: String - Checkout interface language
        - completion `AtlasCheckoutConfigurationCompletion`: `AtlasResult` with success result as `AtlasCheckout` initialized
    */
    public static func configure(options: Options? = nil, completion: AtlasCheckoutConfigurationCompletion) {
        Atlas.configure(options) { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))

            case .success(let client):
                let checkout = AtlasUI(client: client)

                let localizer: Localizer
                do {
                    localizer = try Localizer(localeIdentifier: client.config.interfaceLocale.localeIdentifier)
                    AtlasUI.register { localizer }
                } catch let error {
                    completion(.failure(error))
                }

                AtlasUI.register { OAuth2AuthorizationHandler(loginURL: client.config.loginURL) as AuthorizationHandler }
                AtlasUI.register { client }
                AtlasUI.register { checkout }

                completion(.success(checkout))
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController, forProductSKU sku: String) {
        let atlasUIViewController = AtlasUIViewController(atlasCheckout: self, forProductSKU: sku)

        let checkoutTransitioning = CheckoutTransitioningDelegate()
        atlasUIViewController.transitioningDelegate = checkoutTransitioning
        atlasUIViewController.modalPresentationStyle = .Custom

        AtlasUI.register { atlasUIViewController }

        viewController.presentViewController(atlasUIViewController, animated: true, completion: nil)
    }

    func createCheckoutViewModel(selectedArticleUnit: SelectedArticleUnit,
                                 addresses: CheckoutAddresses? = nil,
                                 completion: CreateCheckoutViewModelCompletion) {

        client.createCheckoutCart(selectedArticleUnit.sku, addresses: addresses) { result in
            switch result {
            case .failure(let error):
                if case let AtlasAPIError.checkoutFailed(cart, _) = error {
                    let checkoutModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit, cart: cart)
                    completion(.success(checkoutModel))
                    if addresses?.billingAddress != nil && addresses?.shippingAddress != nil {
                        UserMessage.displayError(AtlasCheckoutError.checkoutFailure)
                    }
                } else {
                    completion(.failure(error))
                }

            case .success(let result):
                let checkoutModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit,
                                                      cart: result.cart,
                                                      checkout: result.checkout)
                completion(.success(checkoutModel))
            }
        }
    }

    public static func register<T>(factory: Void -> T) {
        injector.register(factory)
    }

    public static func provide<T>() throws -> T {
        return try injector.provide()
    }

}
