//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasAPIClientBaseTests: XCTestCase {

    let cartId = "CART_ID"
    let checkoutId = "CHECKOUT_ID"

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func waitUntilAtlasAPIClientIsConfigured(actions: @escaping (_ done: @escaping () -> Void, _ client: AtlasAPIClient) -> Void) {
        waitUntil(timeout: 10) { done in
            Atlas.configure(options: Options.forTests()) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                    done()
                case .success(let client):
                    actions(done, client)
                }
            }
        }
    }

    func data(withJSONObject object: [String: Any]) -> Data {
        return try! Data(withJSONObject: object)!
    }

    func mockedAtlasAPIClient(forURL url: URL,
                              options: Options? = nil,
                              data: Data?,
                              status: HTTPStatus,
                              errorCode: Int? = nil) -> AtlasAPIClient {

        let apiURL = AtlasMockAPI.endpointURL(forPath: "/")
        let loginURL = AtlasMockAPI.endpointURL(forPath: "/oauth2/authorize")
        let callback = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
        let gateway = "http://localhost.charlesproxy.com:9080"

        let json = JSON([
                            "sales-channels": [
                                [
                                    "locale": "de_DE",
                                    "sales-channel": "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                                    "toc_url": "https://www.zalando.de/agb/"
                                ]
                            ],
                            "atlas-catalog-api": ["url": apiURL.absoluteString],
                            "atlas-checkout-gateway": ["url": gateway],
                            "atlas-checkout-api": [
                                "url": apiURL.absoluteString,
                                "payment": [
                                    "selection-callback": callback,
                                    "third-party-callback": callback
                                ]
                            ],
                            "oauth2-provider": ["url": loginURL.absoluteString]
                        ])

        let config = Config(json: json, options: options ?? Options.forTests())!
        var client = AtlasAPIClient(config: config)

        var error: NSError? = nil
        if let errorCode = errorCode {
            error = NSError(domain: "NSURLErrorDomain", code: errorCode, userInfo: nil)
        }

        client.urlSession = URLSessionMock(data: data, response: HTTPURLResponse(url: url, statusCode: status.rawValue), error: error)

        return client
    }

}
