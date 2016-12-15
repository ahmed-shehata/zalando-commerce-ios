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

        let sdkBundle = Bundle(for: RFC3339DateFormatter.self)
        let sdkId = sdkBundle.version(prefix: "AtlasSDK iOS")

        let appBundle = Bundle.main
        let appId = appBundle.version()

        let expectedVersion = [appId, sdkId, SystemInfo.platform].joined(separator: ", ")
        expect(request?.allHTTPHeaderFields?["User-Agent"]) == expectedVersion
    }

}

