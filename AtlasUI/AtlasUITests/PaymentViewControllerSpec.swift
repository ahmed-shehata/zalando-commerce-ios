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
                let url = AtlasMockAPI.endpointURL(forPath: "/redirect")
                PaymentViewController(paymentURL: url, callbackURL: NSURL(string: "http://google.com")!)
            }
        }
    }

}
