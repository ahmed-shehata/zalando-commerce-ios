//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasTests: XCTestCase {

    var client: AtlasAPIClient?

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
                case .success(let client):
                    self.client = client
                }
                done()
            }
        }
    }

    override func tearDown() {
        self.client = nil
    }

    func testSaveUserToken() {
        loginUser()
        expect(self.client?.isAuthorized) == true
    }

    func testLogoutUser() {
        loginUser()
        logoutUser()
        expect(self.client?.isAuthorized) == false
    }

    func testAtlasAPIClient() {
        expect(self.client?.config.salesChannel.identifier) == "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        expect(self.client?.config.clientId) == "atlas_Y2M1MzA"
        expect(self.client?.config.interfaceLocale.identifier) == "en_DE"
        expect(self.client?.config.availableSalesChannels.count) == 16
    }

}

extension AtlasTests {

    fileprivate func loginUser() {
        client?.authorize(withToken: "TEST_TOKEN")
    }

    fileprivate func logoutUser() {
        client?.deauthorize()
    }

}
