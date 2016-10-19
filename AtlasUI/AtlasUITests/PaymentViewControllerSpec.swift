//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
import AtlasMockAPI
@testable import AtlasUI
@testable import AtlasSDK

class PaymentViewControllerSpec: QuickSpec {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func spec() {
        describe("PaymentViewController") {

            it("Should return .redirect status") {
                guard let paymentViewController = self.paymentViewController(.redirect) else { return }
                waitUntil(timeout: 10) { done in
                    let _ = paymentViewController.view // load the view
                    paymentViewController.paymentCompletion = { result in
                        expect(result.process()).to(equal(PaymentStatus.redirect))
                        done()
                    }
                }
            }

            it("Should return .success status") {
                guard let paymentViewController = self.paymentViewController(.success) else { return }
                waitUntil(timeout: 10) { done in
                    let _ = paymentViewController.view // load the view
                    paymentViewController.paymentCompletion = { result in
                        expect(result.process()).to(equal(PaymentStatus.success))
                        done()
                    }
                }
            }

            it("Should return .cancel status") {
                guard let paymentViewController = self.paymentViewController(.cancel) else { return }
                waitUntil(timeout: 10) { done in
                    let _ = paymentViewController.view // load the view
                    paymentViewController.paymentCompletion = { result in
                        expect(result.process()).to(equal(PaymentStatus.cancel))
                        done()
                    }
                }
            }

            it("Should return .error status") {
                guard let paymentViewController = self.paymentViewController(.error) else { return }
                waitUntil(timeout: 10) { done in
                    let _ = paymentViewController.view // load the view
                    paymentViewController.paymentCompletion = { result in
                        expect(result.process()).to(equal(PaymentStatus.error))
                        done()
                    }
                }
            }
        }
    }

    func paymentViewController(status: PaymentStatus) -> PaymentViewController? {
        guard let callbackURL = NSURL(string: "http://de.zalando.atlas.AtlasCheckoutDemo/redirect") else { return nil }
        let redirectURL: String
        if status == .redirect {
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
        } else {
            redirectURL = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect%3F\(PaymentStatus.statusKey)%3D\(status.rawValue)"
        }
        let url = AtlasMockAPI.endpointURL(forPath: "/redirect", queryItems: [NSURLQueryItem(name: "url", value: redirectURL)])
        return PaymentViewController(paymentURL: url, callbackURL: callbackURL)
    }

}
