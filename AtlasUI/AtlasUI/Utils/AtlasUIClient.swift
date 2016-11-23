//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct AtlasUIClient {

    static func customer(_ completion: @escaping CustomerCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.customer { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCart(withItems cartItemRequests: [CartItemRequest], completion: @escaping CartCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCart(withItems: cartItemRequests) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckoutCart(forSKU sku: String, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCartCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCheckoutCart(forSKU: sku, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckout(fromCardId cartId: String, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCheckout(fromCardId: cartId, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateCheckout(withId checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateCheckout(withId: checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createOrder(fromCheckoutId checkoutId: String, completion: @escaping OrderCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createOrder(fromCheckoutId: checkoutId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func article(withSKU sku: String, completion: @escaping ArticleCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.article(withSKU: sku) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func addresses(_ completion: @escaping AddressesCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.addresses { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func deleteAddress(withId addressId: String, completion: @escaping NoContentCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.deleteAddress(withId: addressId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressCreateUpdateCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateAddress(withAddressId addressId: String,
                              request: UpdateAddressRequest,
                              completion: @escaping AddressCreateUpdateCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateAddress(withAddressId: addressId, request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func checkAddress(_ request: CheckAddressRequest, completion: @escaping CheckAddressCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.checkAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

}
