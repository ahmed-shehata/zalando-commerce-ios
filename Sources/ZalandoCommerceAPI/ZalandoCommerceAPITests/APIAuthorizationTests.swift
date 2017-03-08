//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import MockAPI

@testable import ZalandoCommerceAPI

class APIAuthorizationTests: APITestCase {

    var api: ZalandoCommerceAPI!

    override func setUp() {
        super.setUp()
        waitForAPIConfigured { done, api in
            self.api = api
            done()
        }
    }

    override func tearDown() {
        super.tearDown()
        ZalandoCommerceAPI.deauthorizeAll()
        self.api = nil
    }

    func testAuthorizeClient() {
        loginUser()
        expect(self.api?.isAuthorized) == true
    }

    func testAuthorizeAnotherClient() {
        let liveOptions = Options.forTests(useSandboxEnvironment: false)
        waitForAPIConfigured(options: liveOptions) { done, api in
            let secondClient = api
            secondClient.authorize(with: "ANOTHER_TOKEN")
            expect(self.api?.isAuthorized) == false
            expect(secondClient.isAuthorized) == true
            done()
        }
    }

    func testDeauthorizeClient() {
        loginUser()
        logoutUser()
        expect(self.api?.isAuthorized) == false
    }

    func testWipeTokens() {
        loginUser()
        ZalandoCommerceAPI.deauthorizeAll()
        expect(self.api?.isAuthorized) == false
    }

    func testClientConfig() {
        expect(self.api?.config.salesChannel.identifier) == "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        expect(self.api?.config.clientId) == "atlas_Y2M1MzA"
        expect(self.api?.config.interfaceLocale.identifier) == "en_DE"
        expect(self.api?.config.availableSalesChannels.count) == 16
    }

}

extension APIAuthorizationTests {

    fileprivate func loginUser(token: String = "TEST_TOKEN") {
        self.api?.authorize(with: token)
    }

    fileprivate func logoutUser() {
        self.api?.deauthorize()
    }

}
