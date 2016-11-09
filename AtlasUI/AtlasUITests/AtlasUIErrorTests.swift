//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI

@testable import AtlasUI
@testable import AtlasSDK

class AtlasUIErrorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testUserCancelledError() {
        waitUntil(timeout: 10) { done in
            self.registerAtlasUIViewController {
                let result = AtlasResult<Bool>.failure(AtlasUserError.userCancelled)
                let value = result.process()
                expect(value).to(beNil())
                expect(UserMessage.errorDisplayed).to(equal(false))
                done()
            }
        }
    }

    func testUnclassifiedError() {
        waitUntil(timeout: 10) { done in
            self.registerAtlasUIViewController {
                let result = AtlasResult<Bool >.failure(AtlasCheckoutError.unclassified)
                let value = result.process()
                expect(value).to(beNil())
                expect(UserMessage.errorDisplayed).to(equal(true))
                done()
            }
        }
    }

}

extension AtlasUIErrorTests {

    private func atlasCheckout(completion: (AtlasCheckout -> Void)) {
        let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
        let interfaceLanguage = "en"
        let salesChannelId = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
        let clientId = "CLIENT_ID"
        let options = Options(clientId: clientId,
                              salesChannel: salesChannelId,
                              interfaceLanguage: interfaceLanguage,
                              configurationURL: configURL)

        AtlasCheckout.configure(options) { result in
            guard let checkout = result.process() else { return XCTFail() }
            Async.main {
                completion(checkout)
            }
        }
    }

    private func registerAtlasUIViewController(completion: () -> Void) {
        atlasCheckout { atlasCheckout in
            let atlasUIViewController = AtlasUIViewController(atlasCheckout: atlasCheckout, forProductSKU: "AD541L009-G11")
            AtlasUI.register { atlasUIViewController }
            completion()
        }
    }

}
