//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import MockAPI

@testable import ZalandoCommerceAPI

typealias APIConfiguredCompletion = (_ done: @escaping () -> Void, _ api: ZalandoCommerceAPI) -> Void

class APITestCase: XCTestCase {

    let cartId = "CART_ID"
    let checkoutId = "CHECKOUT_ID"

    override class func setUp() {
        super.setUp()
        try! MockAPI.startServer()
    }

    override class func tearDown() {
        super.tearDown()
        try! MockAPI.stopServer()
    }

    func waitForAPIConfigured(options: Options = Options.forTests(),
                              actions: @escaping APIConfiguredCompletion) {
        waitUntil(timeout: 10) { done in
            ZalandoCommerceAPI.configure(options: options) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                    done()
                case .success(let api):
                    actions(done, api)
                }
            }
        }
    }

    func data(withJSONObject object: [String: Any]) -> Data {
        return try! Data(withJSONObject: object)!
    }

    func mockedAPI(forURL url: URL,
                   options: Options? = nil,
                   data: Data?,
                   status: HTTPStatus,
                   errorCode: Int? = nil) -> ZalandoCommerceAPI {

        let apiURL = MockAPI.endpointURL(forPath: "/")
        let loginURL = MockAPI.endpointURL(forPath: "/oauth2/authorize")
        let callback = "http://com.zalando.commerce.checkout-demo/redirect"
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

        let error: NSError? = errorCode.map { NSError(domain: "NSURLErrorDomain", code: $0, userInfo: nil) }
        let response = HTTPURLResponse(url: url, statusCode: status.rawValue)
        let mockURLSession: URLSession = URLSessionMock(data: data, response: response, error: error)

        return ZalandoCommerceAPI(config: config, session: mockURLSession)
    }

}
