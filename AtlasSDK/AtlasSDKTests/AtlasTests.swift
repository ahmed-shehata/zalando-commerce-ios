//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasTests: XCTestCase {

    var client: AtlasAPI?

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
                    self.client = api
                }
                done()
            }
        }
    }

    override func tearDown() {
        AtlasAPI.deauthorizeAll()
        self.client = nil
    }

    func testAuthorizeClient() {
        loginUser()
        expect(self.client?.isAuthorized) == true
    }

    func testAuthorizeAnotherClient() {
        waitUntil(timeout: 60) { done in
            Atlas.configure(options: Options.forTests(useSandboxEnvironment: false)) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let api):
                    let secondClient = api
                    secondClient.authorize(withToken: "ANOTHER_TOKEN")
                    expect(self.client?.isAuthorized) == false
                    expect(secondClient.isAuthorized) == true
                }
                done()
            }
        }
    }

    func testDeauthorizeClient() {
        loginUser()
        logoutUser()
        expect(self.client?.isAuthorized) == false
    }

    func testWipeTokens() {
        loginUser()
        AtlasAPI.deauthorizeAll()
        expect(self.client?.isAuthorized) == false
    }

    func testClientConfig() {
        expect(self.client?.config.salesChannel.identifier) == "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        expect(self.client?.config.clientId) == "atlas_Y2M1MzA"
        expect(self.client?.config.interfaceLocale.identifier) == "en_DE"
        expect(self.client?.config.availableSalesChannels.count) == 16
    }

}

extension AtlasTests {

    fileprivate func loginUser(token: String = "TEST_TOKEN") {
        self.client?.authorize(withToken: token)
    }

    fileprivate func logoutUser() {
        self.client?.deauthorize()
    }

}
