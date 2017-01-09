//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI

class URLTests: XCTestCase {

    func testRemoveCookies() {
        let url = URL(validURL: "http://foo.bar/baz")
        let urlComponents = URLComponents(validURL: url)
        let cookie = HTTPCookie(properties: [.domain: urlComponents.host!,
                                        .name: "foo",
                                        .value: "bar",
                                        .path: urlComponents.path])!

        let storage = HTTPCookieStorage.shared
        storage.setCookie(cookie)
        expect(storage.cookies(for: url)?.count) == 1

        url.removeCookies(from: storage)
        expect(storage.cookies(for: url)?.count) == 0
    }

}

