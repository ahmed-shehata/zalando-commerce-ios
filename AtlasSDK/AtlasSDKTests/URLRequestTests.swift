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
        let bundle = Bundle(for: RFC3339DateFormatter.self)
        let sdkVersion = bundle.string(for: "CFBundleVersion")!
        let buildVersion = bundle.string(for: "CFBundleShortVersionString")!
        let device = SystemInfo.machine!
        let systemVersion = UIDevice.current.systemVersion

        expect(request?.allHTTPHeaderFields?["User-Agent"]) == "AtlasSDK iOS \(sdkVersion) (\(buildVersion)), \(device)/\(systemVersion)"
    }

}

