//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasCheckout> -> Void

typealias CreateCheckoutViewModelCompletion = AtlasResult<CheckoutViewModel> -> Void

final public class AtlasCheckout {

    public let client: APIClient

    private init(client: APIClient) {
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
                let checkout = AtlasCheckout(client: client)

                let localizer: Localizer
                do {
                    localizer = try Localizer(localeIdentifier: client.config.interfaceLocale.localeIdentifier)
                    Atlas.register { localizer }
                } catch let error {
                    completion(.failure(error))
                }

                Atlas.register { OAuth2AuthorizationHandler(loginURL: client.config.loginURL) as AuthorizationHandler }
                Atlas.register { client }
                Atlas.register { checkout }

                completion(.success(checkout))
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController, forProductSKU sku: String) {
        let atlasUIViewController = AtlasUIViewController(atlasCheckout: self, forProductSKU: sku)

        let checkoutTransitioning = CheckoutTransitioningDelegate()
        atlasUIViewController.transitioningDelegate = checkoutTransitioning
        atlasUIViewController.modalPresentationStyle = .Custom

        Atlas.register { atlasUIViewController }

        viewController.presentViewController(atlasUIViewController, animated: true, completion: nil)
    }

    func createCheckoutViewModel(fromModel checkoutViewModel: CheckoutViewModel,
        completion: CreateCheckoutViewModelCompletion) {
            createCheckoutViewModel(forArticleUnit: checkoutViewModel.selectedArticleUnit,
                addresses: checkoutViewModel.selectedAddresses, completion: completion)
    }

    func createCheckoutViewModel(forArticleUnit selectedArticleUnit: SelectedArticleUnit, addresses: CheckoutAddresses? = nil,
        completion: CreateCheckoutViewModelCompletion) {
            client.createCheckoutCart(for: selectedArticleUnit, addresses: addresses) { result in
                switch result {
                case .failure(let error):
                    if case let AtlasAPIError.checkoutFailed(_, cart, _) = error {
                        let checkoutModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit, cart: cart)
                        completion(.success(checkoutModel))
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

}
