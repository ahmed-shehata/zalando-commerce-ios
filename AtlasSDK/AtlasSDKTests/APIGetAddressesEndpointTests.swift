//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIGetAddressesEndpointTests: XCTestCase {

    func testSalesChannelAsHeader() {
        let endpoint = GetAddressesEndpoint(config: Config.forTests())

        let request = try? URLRequest(endpoint: endpoint)
        expect(request?.allHTTPHeaderFields?["X-Sales-Channel"]).to(equal(TestOptions.salesChannel))
    }

}
