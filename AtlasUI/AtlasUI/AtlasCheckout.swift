//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

public typealias AtlasCheckoutConfigurationCompletion = AtlasResult<AtlasCheckout> -> Void

typealias CreateCheckoutViewModelCompletion = AtlasResult<CheckoutViewModel> -> Void

public class AtlasCheckout: LocalizerProviderType {

    public let client: APIClient
    public let options: Options

    lazy private(set) var localizer: Localizer = Localizer(localizationProvider: self)

    init(client: APIClient, options: Options) {
        self.client = client
        self.options = options
    }

    /**
    Configure AtlasCheckout using Info.plist with the following keys available:
     - ATLASSDK_CLIENT_ID: String - Client Id (required)
     - ATLASSDK_SALES_CHANNEL: String - Sales Channel (required)
     - ATLASSDK_USE_SANDBOX: Bool - Indicates whether sandbox environment should be used
     - ATLASSDK_INTERFACE_LANGUAGE: String - Checkout interface language

     - Parameters:
        - completion `AtlasCheckoutConfigurationCompletion`: `AtlasResult` with success result as `AtlasCheckout` initialized
     */
    public static func configure(completion: AtlasCheckoutConfigurationCompletion) {
        let options = Options(bundle: NSBundle.mainBundle())
        AtlasCheckout.configure(options, completion: completion)
    }

    /**
     Configure AtlasCheckout manually.

     - Parameters:
        - options `Options`: provide an `Options` instance with at least 2 mandatory parameters **clientId** and **salesChannel**
        - completion `AtlasCheckoutConfigurationCompletion`: `AtlasResult` with success result as `AtlasCheckout` initialized
    */
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

extension AtlasCheckout: Localizable {

    var localizedStringsBundle: NSBundle {
        return NSBundle(forClass: AtlasCheckout.self)
    }

    var localeIdentifier: String {
        return options.interfaceLanguage
    }

}
