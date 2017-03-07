//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import ZalandoCommerceAPI
import UIKit

extension AtlasAPI {

    struct withLoader { // swiftlint:disable:this type_name

        static func customer(completion: @escaping APIResultCompletion<Customer>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.customer { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createCart(cartItemRequests: [CartItemRequest],
                               completion: @escaping APIResultCompletion<Cart>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createCart(with: cartItemRequests) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createCartCheckout(for selectedArticle: SelectedArticle,
                                       addresses: CheckoutAddresses? = nil,
                                       completion: @escaping APIResultCompletion<CartCheckout>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
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
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createCheckout(from: cartId, addresses: addresses) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func updateCheckout(with checkoutId: CheckoutId,
                                   updateCheckoutRequest: UpdateCheckoutRequest,
                                   completion: @escaping APIResultCompletion<Checkout>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.updateCheckout(with: checkoutId, updateCheckoutRequest: updateCheckoutRequest) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createOrder(from checkout: Checkout,
                                completion: @escaping APIResultCompletion<Order>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createOrder(from: checkout) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createGuestOrder(request: GuestOrderRequest,
                                     completion: @escaping APIResultCompletion<GuestOrder>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createGuestOrder(request: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func guestCheckoutPaymentSelectionURL(request: GuestPaymentSelectionRequest,
                                                     completion: @escaping APIResultCompletion<URL>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.guestCheckoutPaymentSelectionURL(request: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func guestCheckout(with guestCheckoutId: GuestCheckoutId,
                                  completion: @escaping APIResultCompletion<GuestCheckout>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.guestCheckout(with: guestCheckoutId) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func article(with sku: ConfigSKU,
                            completion: @escaping APIResultCompletion<Article>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.article(with: sku) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func recommendations(for sku: ConfigSKU, onView view: UIView,
                                    completion: @escaping APIResultCompletion<[Recommendation]>) {
            ZalandoCommerceUIViewController.displayLoader(onView: view) { hideLoader in
                AtlasAPI.shared?.recommendations(for: sku) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func addresses(completion: @escaping APIResultCompletion<[UserAddress]>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.addresses { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func delete(_ address: EquatableAddress,
                           completion: @escaping APIResultCompletion<Bool>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.delete(address) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func createAddress(with request: CreateAddressRequest,
                                  completion: @escaping APIResultCompletion<UserAddress>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.createAddress(with: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func updateAddress(with request: UpdateAddressRequest,
                                  completion: @escaping APIResultCompletion<UserAddress>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.updateAddress(with: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

        static func checkAddress(_ request: CheckAddressRequest,
                                 completion: @escaping APIResultCompletion<CheckAddressResponse>) {
            ZalandoCommerceUIViewController.displayLoader { hideLoader in
                AtlasAPI.shared?.checkAddress(with: request) { result in
                    hideLoader()
                    completion(result)
                }
            }
        }

    }

}
