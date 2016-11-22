//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct AtlasUIClient {

    static func customer(completion: CustomerCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.customer { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCart(cartItemRequests: [CartItemRequest], completion: CartCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createCart(cartItemRequests) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckoutCart(sku: String, addresses: CheckoutAddresses? = nil, completion: CheckoutCartCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createCheckoutCart(sku, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckout(cartId: String, addresses: CheckoutAddresses? = nil, completion: CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createCheckout(cartId, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateCheckout(checkoutId: String, updateCheckoutRequest: UpdateCheckoutRequest, completion: CheckoutCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.updateCheckout(checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createOrder(checkoutId: String, completion: OrderCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createOrder(checkoutId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createGuestOrder(request: CreateGuestOrderRequest, completion: GuestOrderCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createGuestOrder(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func article(sku: String, completion: ArticleCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.article(sku) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func addresses(completion: AddressesCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.addresses { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func deleteAddress(addressId: String, completion: NoContentCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.deleteAddress(addressId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createAddress(request: CreateAddressRequest, completion: AddressCreateUpdateCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.createAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateAddress(addressId: String, request: UpdateAddressRequest, completion: AddressCreateUpdateCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.updateAddress(addressId, request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func checkAddress(request: CheckAddressRequest, completion: CheckAddressCompletion) {
        UserMessage.displayLoader { hideLoader in
            AtlasAPIClient.instance?.checkAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

}
