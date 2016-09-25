//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasCheckout> -> Void

typealias CreateCheckoutViewModelCompletion = AtlasResult<CheckoutViewModel> -> Void

public class AtlasCheckout {

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
                completion(.failure(error))

            case .success(let client):
                let checkout = AtlasCheckout(client: client)
                let localizer = UILocalizer(localeIdentifier: client.config.locale.localeIdentifier,
                    localizedStringsBundle: NSBundle(forClass: AtlasCheckout.self))

                Atlas.register { OAuth2AuthorizationHandler(loginURL: client.config.loginURL) as AuthorizationHandler }
                Atlas.register { localizer }
                Atlas.register { client }

                completion(.success(checkout))
            }
        }
    }

    public func presentCheckout(onViewController viewController: UIViewController, forProductSKU sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(checkout: self, sku: sku)
        let checkoutTransitioning = CheckoutTransitioningDelegate()

        let navigationController = UINavigationController(rootViewController: sizeSelectionViewController)
        navigationController.transitioningDelegate = checkoutTransitioning
        navigationController.modalPresentationStyle = .Custom

        viewController.presentViewController(navigationController, animated: true, completion: nil)
    }

    func prepareCheckoutViewModel(selectedArticleUnit: SelectedArticleUnit, checkoutViewModel: CheckoutViewModel? = nil,
        completion: CreateCheckoutViewModelCompletion) {
            client.createCheckout(withSelectedArticleUnit: selectedArticleUnit,
                billingAddressId: checkoutViewModel?.selectedBillingAddress?.id,
                shippingAddressId: checkoutViewModel?.selectedShippingAddress?.id) { checkoutResult in
                    switch checkoutResult {
                    case .failure(let error):
                        if case let AtlasAPIError.checkoutFailed(_, cartId, _) = error {
                            let checkoutModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit, cartId: cartId, checkout: nil)
                            completion(.success(checkoutModel))
                        }

                    case .success(let checkout):
                        let checkoutModel = CheckoutViewModel(selectedArticleUnit: selectedArticleUnit, checkout: checkout)
                        completion(.success(checkoutModel))
                    }
            }
    }

}

extension APIClient {

    static var client: APIClient? = {
        try? Atlas.provide() as APIClient
    }()

}
