//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct AtlasUIClient {

    static func customer(completion: @escaping CustomerCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.customer { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCart(cartItemRequests: [CartItemRequest], completion: @escaping CartCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCart(withItems: cartItemRequests) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckoutCart(forSelectedArticle selectedArticle: SelectedArticle,
                                   addresses: CheckoutAddresses? = nil,
                                   completion: @escaping CheckoutCartCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCheckoutCart(forSelectedArticle: selectedArticle, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createCheckout(from cartId: CartId, addresses: CheckoutAddresses? = nil, completion: @escaping CheckoutCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createCheckout(from: cartId, addresses: addresses) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateCheckout(with checkoutId: CheckoutId,
                               updateCheckoutRequest: UpdateCheckoutRequest,
                               completion: @escaping CheckoutCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateCheckout(with: checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createOrder(from checkoutId: CheckoutId, completion: @escaping OrderCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createOrder(from: checkoutId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createGuestOrder(request: GuestOrderRequest, completion: @escaping GuestOrderCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createGuestOrder(request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest, completion: @escaping URLCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.guestCheckoutPaymentSelectionURL(request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func guestCheckout(with checkoutId: CheckoutId, token: CheckoutToken, completion: @escaping GuestCheckoutCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.guestCheckout(with: checkoutId, token: token) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func article(with sku: ColorSKU, completion: @escaping ArticleCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.article(with: sku) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func addresses(completion: @escaping AddressesCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.addresses { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func deleteAddress(with addressId: AddressId, completion: @escaping SuccessCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.deleteAddress(with: addressId) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func createAddress(_ request: CreateAddressRequest, completion: @escaping AddressChangeCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.createAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func updateAddress(with addressId: AddressId, request: UpdateAddressRequest, completion: @escaping AddressChangeCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.updateAddress(with: addressId, request: request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

    static func checkAddress(_ request: CheckAddressRequest, completion: @escaping AddressCheckCompletion) {
        AtlasUIViewController.displayLoader { hideLoader in
            AtlasAPIClient.shared?.checkAddress(request) { result in
                hideLoader()
                completion(result)
            }
        }
    }

}
