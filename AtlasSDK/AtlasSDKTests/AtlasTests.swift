//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testSaveUserToken() {
        loginUser()
        expect(Atlas.isUserLoggedIn()).to(beTrue())
    }

    func testLogoutUser() {
        loginUser()
        Atlas.logoutUser()
        expect(Atlas.isUserLoggedIn()).to(beFalse())
    }

    func testAPIClient() {
        let opts = Options(clientId: "atlas_Y2M1MzA",
                           salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                           useSandbox: true,
                           interfaceLanguage: "de",
                           configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"),
                           authorizationHandler: MockAuthorizationHandler())

        waitUntil(timeout: 60) { done in
            Atlas.configure(opts) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .success(let client):
                    expect(client).toNot(beNil())
                }
                done()
            }
        }
    }

}

extension AtlasTests {

    private func loginUser() {
        APIAccessToken.store("TEST_TOKEN")
    }

}
