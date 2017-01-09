//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI
import AtlasSDK

@testable import AtlasUI

class UITestCase: XCTestCase {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()

        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            AtlasUI.configure(options: opts) { result in
                if case let .failure(error) = result {
                    fail(String(describing: error))
                }
                done()
            }
        }
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    override func setUp() {
        super.setUp()
        UserMessage.resetBanners()
    }

}
