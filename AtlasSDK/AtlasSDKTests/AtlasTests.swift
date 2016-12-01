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
        expect(Atlas.isAuthorized()).to(beTrue())
    }

    func testLogoutUser() {
        loginUser()
        Atlas.deauthorize()
        expect(Atlas.isAuthorized()).to(beFalse())
    }

    func testAtlasAPIClient() {
        waitUntil(timeout: 60) { done in
            Atlas.configure(options: Options.forTests()) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let client):
                    expect(client.config.salesChannel.identifier).to(equal("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
                    expect(client.config.clientId).to(equal("CLIENT_ID"))
                    expect(client.config.interfaceLocale.identifier).to(equal("en_DE"))
                    expect(client.config.availableSalesChannels.count).to(equal(16))
                }
                done()
            }
        }
    }

}

extension AtlasTests {

    fileprivate func loginUser() {
        APIAccessToken.store(token: "TEST_TOKEN")
    }

}
