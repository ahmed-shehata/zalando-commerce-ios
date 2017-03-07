//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import MockAPI

@testable import ZalandoCommerceUI
@testable import ZalandoCommerceAPI

class PaymentViewControllerTests: UITestCase {

    func testGuestRedirectStatus() {
        let guestCheckoutId = GuestCheckoutId(checkoutId: "CHECKOUT_ID", token: "TOKEN")

        guard let paymentViewController = self.paymentViewController(with: .guestRedirect(guestCheckoutId: guestCheckoutId))
            else { return }

        waitUntil(timeout: 10) { done in
            paymentViewController.paymentCompletion = { result in
                expect(result) == PaymentStatus.guestRedirect(guestCheckoutId: guestCheckoutId)
                done()
            }
            self.defaultNavigationController?.pushViewController(paymentViewController, animated: true)
        }
    }

    func testRedirectStatus() {
        guard let paymentViewController = self.paymentViewController(with: .redirect) else { return }
        waitUntil(timeout: 10) { done in
            paymentViewController.paymentCompletion = { result in
                expect(result) == PaymentStatus.redirect
                done()
            }
            self.defaultNavigationController?.pushViewController(paymentViewController, animated: true)
        }
    }

    func testSuccessStatus() {
        guard let paymentViewController = self.paymentViewController(with: .success) else { return }
        waitUntil(timeout: 10) { done in
            paymentViewController.paymentCompletion = { result in
                expect(result) == PaymentStatus.success
                done()
            }
            self.defaultNavigationController?.pushViewController(paymentViewController, animated: true)
        }
    }

    func testCancelStatus() {
        guard let paymentViewController = self.paymentViewController(with: .cancel) else { return }
        waitUntil(timeout: 10) { done in
            paymentViewController.paymentCompletion = { result in
                expect(result) == PaymentStatus.cancel
                done()
            }
            self.defaultNavigationController?.pushViewController(paymentViewController, animated: true)
        }
    }

    func testErrorStatus() {
        guard let paymentViewController = self.paymentViewController(with: .error) else { return }
        waitUntil(timeout: 10) { done in
            paymentViewController.paymentCompletion = { result in
                expect(result) == PaymentStatus.error
                done()
            }
            self.defaultNavigationController?.pushViewController(paymentViewController, animated: true)
        }
    }

}

extension PaymentViewControllerTests {

    fileprivate func paymentViewController(with status: PaymentStatus) -> PaymentViewController? {
        let callbackURL: String
        let redirectURL: String
        switch status {
        case .guestRedirect(let guestCheckoutId):
            callbackURL = "https://atlas-checkout-gateway.com/redirect"
            redirectURL = "https://atlas-checkout-gateway.com/redirect/\(guestCheckoutId.checkoutId)/\(guestCheckoutId.token)"
        case .redirect:
            callbackURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
        case .success:
            callbackURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect%3F\(PaymentStatus.statusKey)%3Dsuccess"
        case .cancel:
            callbackURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect%3F\(PaymentStatus.statusKey)%3Dcancel"
        case .error:
            callbackURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect%3F\(PaymentStatus.statusKey)%3Derror"
        }
        let url = MockAPI.endpointURL(forPath: "/redirect", queryItems: [URLQueryItem(name: "url", value: redirectURL)])
        let callback = URL(string: callbackURL)!
        return PaymentViewController(paymentURL: url, callbackURL: callback)
    }

}
