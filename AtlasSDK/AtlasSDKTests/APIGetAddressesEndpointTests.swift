//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIGetAddressesEndpointTests: XCTestCase {

    func testSalesChannelAsHeader() {
        let salesChannel = "SALES_CHANNEL"
        let endpoint = GetAddressesEndpoint(serviceURL: URL(validUrl: "http://example.com"),
                                            salesChannel: salesChannel)

        let request = try? URLRequest(endpoint: endpoint)
        expect(request?.allHTTPHeaderFields?["X-Sales-Channel"]).to(equal(salesChannel))
    }

}
