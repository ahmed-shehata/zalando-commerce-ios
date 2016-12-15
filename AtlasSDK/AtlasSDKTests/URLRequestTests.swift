//
//   Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class URLRequestTests: XCTestCase {

    func testUserAgentHeader() {
        let endpoint = GetConfigEndpoint(url: TestConsts.configURL)

        let request = try? URLRequest(endpoint: endpoint)
        let version = Bundle(for: RFC3339DateFormatter.self).string(for: "CFBundleVersion")!

        expect(request?.allHTTPHeaderFields?["User-Agent"]) == "AtlasSDK v.\(version)"
    }

}

