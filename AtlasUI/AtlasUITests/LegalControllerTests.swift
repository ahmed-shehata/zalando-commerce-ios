//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasSDK

@testable import AtlasUI

class LegalControllerTests: XCTestCase {

    func testIncorrectLegalPage() {
        expect(self.hasCorrectLegalURL("https://www.google.com/")).to(beFalse())
    }

    func testCorrectLegalPageDE() {
        expect(self.hasCorrectLegalURL("https://www.zalando.de/")).to(beTrue())
    }



    private func hasCorrectLegalURL(tocUrl: String) -> Bool {
        var hasCorrectURL = false

        let url = NSURL(validURL: tocUrl)
        let legalController = LegalController(tocURL: url)
        legalController.presentLegalViewController()

        waitUntil(timeout: 10) { done in
            let controller = UIApplication.topViewController()
            hasCorrectURL = controller != nil
            done()
        }

        return hasCorrectURL
    }

}

