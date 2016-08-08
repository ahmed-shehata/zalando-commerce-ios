//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension AtlasSDK {

    public static func configure(options: Options, configurationURL: NSURL? = nil) {
        if let configurationURL = configurationURL {
            AtlasSDK.sharedInstance.register { ConfigClient(options: options, endpointURL: configurationURL) as Configurator }
        }
        AtlasSDK.sharedInstance.setup(options)
    }

    public static func configure(interfaceLanguage interfaceLanguage: String) {
        AtlasSDK.sharedInstance.updateOptions { var opts = $0
            opts.interfaceLanguage = interfaceLanguage
            return opts
        }
    }

    /**
     Returns `Customer` struct in completion block or an error

     - parameter completion: CustomerCompletion
     - returns: Void
     */
    public static func fetchCustomer(completion: CustomerCompletion) {
        guard isAtlasSetupCorrectly(completion) else { return }
        AtlasSDK.sharedInstance.apiClient?.customer(completion)
    }

    public static func isUserLoggedIn() -> Bool {
        return APIAccessToken.retrieve() != nil
    }

    public static func logoutCustomer() {
        APIAccessToken.delete()
    }

    /**
     Fetches the `AtlasResult` of `Catalog` for the articles with the given sku
     and configured sales_cahnnel and executes the __completion block__ provided.

     - parameter sku: Article SKU
     - parameter completion: `ArticleCompletion`
     - returns: Void
     */
    public static func fetchArticle(sku sku: String, completion: ArticleCompletion) {
        guard isAtlasSetupCorrectly(completion) else { return }
        AtlasSDK.sharedInstance.apiClient?.article(forSKU: sku, completion: completion)
    }

    public static func createCart(cartItemRequests: CartItemRequest..., completion: CartCompletion) {
        guard isAtlasSetupCorrectly(completion) else { return }
        AtlasSDK.sharedInstance.apiClient?.createCart(cartItemRequests, completion: completion)
    }

    public static func createCheckout(cartId: String, billingAddressId: String? = nil,
        shippingAddressId: String? = nil, completion: CheckoutCompletion) {
            guard isAtlasSetupCorrectly(completion) else { return }
            AtlasSDK.sharedInstance.apiClient?.createCheckout(cartId, billingAddressId: billingAddressId,
                shippingAddressId: shippingAddressId, checkoutCompletion: completion)
    }

    public static func createOrder(checkoutId: String, completion: OrderCompletion) {
        guard isAtlasSetupCorrectly(completion) else { return }
        AtlasSDK.sharedInstance.apiClient?.createOrder(checkoutId, orderCompletion: completion)
    }

    public static func fetchAddresses(completion: AddressesCompletion) {
        guard isAtlasSetupCorrectly(completion) else { return }
        AtlasSDK.sharedInstance.apiClient?.fetchAddressList(completion)
    }

    private static func isAtlasSetupCorrectly<T>(completion: AtlasResult<T> -> Void) -> Bool {
        guard AtlasSDK.sharedInstance.status == .ConfigurationOK else {
            let error = AtlasConfigurationError(status: AtlasSDK.sharedInstance.status)
            completion(.failure(error))
            return false
        }
        return true
    }

}
