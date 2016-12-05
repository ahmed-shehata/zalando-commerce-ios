//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import SwiftHTTP
import SwiftyJSON
import Nimble

@testable import AtlasMockAPI

private typealias JSONCompletion = (JSON) -> Void
private typealias DataCompletion = (Data) -> Void

class AtlasMockAPITests: XCTestCase {

    override static func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()
    }

    override static func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testRootEndpoint() {
        assertSuccessfulResponse(forEndpoint: "/") { data in
            expect(data.count).toNot(equal(0))
        }
    }

    func testCatalogEndpoint() {
        assertSuccessfulJSONResponse(forEndpoint: "/articles") { json in
            expect(json["content", 0, "id"].stringValue).to(equal("L2711E002-Q11"))
        }
    }

    func testArticleEndpoint() {
        assertSuccessfulJSONResponse(forEndpoint: "/articles/AD541L009-G11") { json in
            expect(json["units", 0, "id"].stringValue).to(equal("AD541L009-G11000S000"))
        }
    }

    func testAuthorizeEndpoint() {
        assertSuccessfulResponse(forEndpoint: "/oauth2/authorize") { data in
            if let html = String(data: data, encoding: String.Encoding.utf8) {
                expect(html).to(contain("value=\"qux-quux-corge\""))
            }
        }
    }

    fileprivate func assertSuccessfulJSONResponse(forEndpoint endpoint: String, completion: JSONCompletion? = nil) {
        assertSuccessfulResponse(forEndpoint: endpoint) { data in
            let json = SwiftyJSON.JSON(data: data)
            expect(json).toNot(beNil())
            completion?(json)
        }
    }

    fileprivate func assertSuccessfulResponse(forEndpoint endpoint: String, completion: DataCompletion? = nil) {
        let expectation = self.expectation(description: "assertSuccessfulResponse \(endpoint)")
        let url = AtlasMockAPI.endpointURL(forPath: endpoint).absoluteString

        if let operation = try? HTTP.GET(url) {
            operation.start { response in
                completion?(response.data)
                expectation.fulfill()
            }

        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }

}
