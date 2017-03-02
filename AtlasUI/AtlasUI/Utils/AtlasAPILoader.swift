//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import UIKit

extension AtlasAPI {

    struct withLoader { // swiftlint:disable:this type_name

        static func customer(completion: @escaping APIResultCompletion<Customer>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.customer { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createCart(cartItemRequests: [CartItemRequest],
                               completion: @escaping APIResultCompletion<Cart>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createCart(with: cartItemRequests) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createCartCheckout(for selectedArticle: SelectedArticle,
                                       addresses: CheckoutAddresses? = nil,
                                       completion: @escaping APIResultCompletion<CartCheckout>) {
            AtlasUIViewController.displayLoader { hideLoader in
                let cartItemRequest = CartItemRequest(sku: selectedArticle.sku, quantity: selectedArticle.quantity)
                AtlasAPI.shared?.createCartCheckout(with: cartItemRequest, addresses: addresses) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createCheckout(from cartId: CartId,
                                   addresses: CheckoutAddresses? = nil,
                                   completion: @escaping APIResultCompletion<Checkout>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createCheckout(from: cartId, addresses: addresses) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func updateCheckout(with checkoutId: CheckoutId,
                                   updateCheckoutRequest: UpdateCheckoutRequest,
                                   completion: @escaping APIResultCompletion<Checkout>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.updateCheckout(with: checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createOrder(from checkoutId: CheckoutId,
                                completion: @escaping APIResultCompletion<Order>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createOrder(from: checkoutId) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createGuestOrder(request: GuestOrderRequest,
                                     completion: @escaping APIResultCompletion<GuestOrder>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createGuestOrder(request: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest,
                                                     completion: @escaping APIResultCompletion<URL>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.guestCheckoutPaymentSelectionURL(request: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func guestCheckout(with checkoutId: CheckoutId, token: GuestCheckoutToken,
                                  completion: @escaping APIResultCompletion<GuestCheckout>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.guestCheckout(with: checkoutId, token: token) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func article(with sku: ConfigSKU,
                            completion: @escaping APIResultCompletion<Article>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.article(with: sku) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func recommendations(forSKU sku: ConfigSKU, onView view: UIView,
                                    completion: @escaping APIResultCompletion<[Recommendation]>) {
            AtlasUIViewController.displayLoader(onView: view) { hideLoader in
                AtlasAPI.shared?.recommendations(forSKU: sku) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func addresses(completion: @escaping APIResultCompletion<[UserAddress]>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.addresses { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func deleteAddress(with addressId: AddressId,
                                  completion: @escaping APIResultCompletion<Bool>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.deleteAddress(with: addressId) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createAddress(_ request: CreateAddressRequest,
                                  completion: @escaping APIResultCompletion<UserAddress>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createAddress(with: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func updateAddress(with addressId: AddressId,
                                  request: UpdateAddressRequest,
                                  completion: @escaping APIResultCompletion<UserAddress>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.updateAddress(with: addressId, request: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func checkAddress(_ request: CheckAddressRequest,
                                 completion: @escaping APIResultCompletion<CheckAddressResponse>) {
            AtlasUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.checkAddress(with: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

    }

}
