//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct AtlasUIClient {

    static func customer(completion: @escaping CustomerCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.customer { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCart(cartItemRequests: [CartItemRequest], completion: @escaping CartCompletion) {
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

    static func createCheckout(cartId: String, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCheckout(fromCardId: cartId, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: @escaping CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateCheckout(withId: checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createOrder(checkoutId: String, completion: @escaping OrderCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createOrder(fromCheckoutId: checkoutId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createGuestOrder(request: GuestOrderRequest, completion: @escaping GuestOrderCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createGuestOrder(request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest, completion: @escaping URLCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.guestCheckoutPaymentSelectionURL(request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func guestCheckout(checkoutId: String, token: String, completion: @escaping GuestCheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.guestCheckout(checkoutId: checkoutId, token: token) { result in
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

    static func addresses(completion: @escaping AddressesCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.addresses { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func deleteAddress(withId addressId: String, completion: @escaping SuccessCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.deleteAddress(withId: addressId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressChangeCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateAddress(addressId: String, request: UpdateAddressRequest, completion: @escaping AddressChangeCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateAddress(withId: addressId, request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func checkAddress(_ request: CheckAddressRequest, completion: @escaping AddressCheckCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.shared?.checkAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

}
