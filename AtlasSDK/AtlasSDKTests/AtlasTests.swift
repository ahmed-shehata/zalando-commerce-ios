//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasTests: XCTestCase {

    var api: AtlasAPI?

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    override func setUp() {
        waitUntil(timeout: 60) { done in
            Atlas.configure(options: Options.forTests()) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let api):
                    self.api = api
                }
                done()
            }
        }
    }

    override func tearDown() {
        AtlasAPI.deauthorizeAll()
        self.api = nil
    }

    func testAuthorizeClient() {
        loginUser()
        expect(self.api?.isAuthorized) == true
    }

    func testAuthorizeAnotherClient() {
        waitUntil(timeout: 60) { done in
            Atlas.configure(options: Options.forTests(useSandboxEnvironment: false)) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let api):
                    let secondClient = api
                    secondClient.authorize(with: "ANOTHER_TOKEN")
                    expect(self.api?.isAuthorized) == false
                    expect(secondClient.isAuthorized) == true
                }
                done()
            }
        }
    }

    func testDeauthorizeClient() {
        loginUser()
        logoutUser()
        expect(self.api?.isAuthorized) == false
    }

    func testWipeTokens() {
        loginUser()
        AtlasAPI.deauthorizeAll()
        expect(self.api?.isAuthorized) == false
    }

    func testClientConfig() {
        expect(self.api?.config.salesChannel.identifier) == "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        expect(self.api?.config.clientId) == "atlas_Y2M1MzA"
        expect(self.api?.config.interfaceLocale.identifier) == "en_DE"
        expect(self.api?.config.availableSalesChannels.count) == 16
    }

}

extension AtlasTests {

    fileprivate func loginUser(token: String = "TEST_TOKEN") {
        self.api?.authorize(with: token)
    }

    fileprivate func logoutUser() {
        self.api?.deauthorize()
    }

}
