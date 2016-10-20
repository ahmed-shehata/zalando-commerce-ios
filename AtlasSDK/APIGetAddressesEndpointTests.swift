//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Nimble

@testable import AtlasSDK

class APISalesChannelSpec: QuickSpec {

    override func spec() {

        describe("GetAddressesEndpoint") {

            it("should pass sales channel as header") {
                let salesChannel = "SALES_CHANNEL"
                let endpoint = GetAddressesEndpoint(serviceURL: NSURL(validURL: "http://example.com"),
                    salesChannel: salesChannel)

                let request = try? NSMutableURLRequest(endpoint: endpoint)

                expect(request?.allHTTPHeaderFields?["X-Sales-Channel"]).to(equal(salesChannel))
            }

        }
    }

}
