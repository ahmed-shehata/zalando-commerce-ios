//
//   Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI

class URLRequestTests: XCTestCase {

    func testLanguageHeader() {
        let url = URL(validURL: "http://zalando.de")
        let language = "fr"
        let request = URLRequest(url: url, language: language)

        guard let languageField = request.allHTTPHeaderFields?["Accept-Language"] else {
            fail("No Accept-Language header")
            return
        }

        expect(languageField).to(contain("\(language);q=1.0"))
    }


}

