//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class PaymentViewControllerTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testGuestRedirectStatus() {
        guard let paymentViewController = self.paymentViewController(.guestRedirect(encryptedCheckoutId: "encryptedCheckoutId", encryptedToken: "encryptedToken")) else { return }
        waitUntil(timeout: 10) { done in
            let _ = paymentViewController.view // load the view
            paymentViewController.paymentCompletion = { result in
                expect(result).to(equal(PaymentStatus.guestRedirect(encryptedCheckoutId: "encryptedCheckoutId", encryptedToken: "encryptedToken")))
                done()
            }
        }
    }

    func testRedirectStatus() {
        guard let paymentViewController = self.paymentViewController(.redirect) else { return }
        waitUntil(timeout: 10) { done in
            let _ = paymentViewController.view // load the view
            paymentViewController.paymentCompletion = { result in
                expect(result).to(equal(PaymentStatus.redirect))
                done()
            }
        }
    }

    func testSuccessStatus() {
        guard let paymentViewController = self.paymentViewController(.success) else { return }
        waitUntil(timeout: 10) { done in
            let _ = paymentViewController.view // load the view
            paymentViewController.paymentCompletion = { result in
                expect(result).to(equal(PaymentStatus.success))
                done()
            }
        }
    }

    func testCancelStatus() {
        guard let paymentViewController = self.paymentViewController(.cancel) else { return }
        waitUntil(timeout: 10) { done in
            let _ = paymentViewController.view // load the view
            paymentViewController.paymentCompletion = { result in
                expect(result).to(equal(PaymentStatus.cancel))
                done()
            }
        }
    }

    func testErrorStatus() {
        guard let paymentViewController = self.paymentViewController(.error) else { return }
        waitUntil(timeout: 10) { done in
            let _ = paymentViewController.view // load the view
            paymentViewController.paymentCompletion = { result in
                expect(result).to(equal(PaymentStatus.error))
                done()
            }
        }
    }

}

extension PaymentViewControllerTests {

    private func paymentViewController(status: PaymentStatus) -> PaymentViewController? {
        let callbackURL: String
        let redirectURL: String
        switch status {
        case .guestRedirect(let encryptedCheckoutId, let encryptedToken):
            callbackURL = "http://localhost.charlesproxy.com:9080/redirect"
            redirectURL = "http://localhost.charlesproxy.com:9080/redirect/\(encryptedCheckoutId)/\(encryptedToken)"
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
        let url = AtlasMockAPI.endpointURL(forPath: "/redirect", queryItems: [NSURLQueryItem(name: "url", value: redirectURL)])
        return PaymentViewController(paymentURL: url, callbackURL: NSURL(string: callbackURL)!)
    }

}
