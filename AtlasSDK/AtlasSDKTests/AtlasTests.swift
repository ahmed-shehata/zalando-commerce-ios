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
        Atlas.deauthorizeToken()
        expect(Atlas.isAuthorized()).to(beFalse())
    }

    func testAtlasAPIClient() {
        let opts = Options(clientId: "atlas_Y2M1MzA",
                           salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                           useSandbox: true,
                           interfaceLanguage: "de",
                           configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        waitUntil(timeout: 60) { done in
            Atlas.configure(opts) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .success(let client):
                    expect(client.config.salesChannel.identifier).to(equal("82fe2e7f-8c4f-4aa1-9019-b6bde5594456"))
                    expect(client.config.clientId).to(equal("atlas_Y2M1MzA"))
                    expect(client.config.interfaceLocale.localeIdentifier).to(equal("de_DE"))
                    expect(client.config.availableSalesChannels.count).to(equal(16))
                }
                done()
            }
        }
    }

}

extension AtlasTests {

    fileprivate func loginUser() {
        APIAccessToken.store("TEST_TOKEN")
    }

}
