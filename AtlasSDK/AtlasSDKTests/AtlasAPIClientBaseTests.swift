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

    private var clientOptions: Options {
        return Options(clientId: "atlas_Y2M1MzA",
            salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
            useSandbox: true,
            interfaceLanguage: "de",
            configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
    }

    func waitUntilAtlasAPIClientIsConfigured(actions: (done: () -> Void, client: AtlasAPIClient) -> Void) {
        waitUntil(timeout: 10) { done in
            Atlas.configure(self.clientOptions) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                    done()
                case .success(let client):
                    actions(done: done, client: client)
                }
            }
        }
    }

    func dataWithJSONObject(object: AnyObject) -> NSData {
        return try! NSJSONSerialization.dataWithJSONObject(object, options: [])
    }

    func mockedAtlasAPIClient(forURL url: NSURL,
                                options: Options? = nil,
                                data: NSData?,
                                status: HTTPStatus,
                                errorCode: Int? = nil) -> AtlasAPIClient {

        let apiURL = AtlasMockAPI.endpointURL(forPath: "/")
        let loginURL = AtlasMockAPI.endpointURL(forPath: "/oauth2/authorize")
        let callback = "http://de.zalando.atlas.AtlasCheckoutDemo/redirect"
        let gateway = "http://localhost.charlesproxy.com:9080"

        let json = JSON(
            [
                "sales-channels": [
                    [
                        "locale": "de_DE",
                        "sales-channel": "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                        "toc_url": "https://www.zalando.de/agb/"
                    ]
                ],
                "atlas-catalog-api": ["url": apiURL.absoluteString!],
                "atlas-checkout-gateway": ["url": gateway],
                "atlas-checkout-api": [
                    "url": apiURL.absoluteString!,
                    "payment": [
                        "selection-callback": callback,
                        "third-party-callback": callback
                    ]
                ],
                "oauth2-provider": ["url": loginURL.absoluteString!]
            ]
        )

        let config = Config(json: json, options: options ?? clientOptions)!
        var client = AtlasAPIClient(config: config)

        var error: NSError? = nil
        if let errorCode = errorCode {
            error = NSError(domain: "NSURLErrorDomain", code: errorCode, userInfo: nil)
        }

        client.urlSession = URLSessionMock(data: data, response: NSHTTPURLResponse(URL: url, statusCode: status.rawValue), error: error)

        return client
    }

}
