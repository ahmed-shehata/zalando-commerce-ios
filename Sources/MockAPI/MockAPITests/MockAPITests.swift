//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import SwiftHTTP
import Freddy
import Nimble

@testable import MockAPI

private typealias JSONCompletion = (JSON) -> Void
private typealias DataCompletion = (Data) -> Void

class MockAPITests: XCTestCase {

    override static func setUp() {
        super.setUp()
        try! MockAPI.startServer()
    }

    override static func tearDown() {
        super.tearDown()
        try! MockAPI.stopServer()
    }

    func testRootEndpoint() {
        assertSuccessfulResponse(forEndpoint: "/") { data in
            expect(data.count).toNot(equal(0))
        }
    }

    func testCatalogEndpoint() {
        assertSuccessfulJSONResponse(forEndpoint: "/articles") { json in
            expect(try! json.getString(at: "content", 0, "id")) == "L2711E002-Q11"
        }
    }

    func testArticleEndpoint() {
        assertSuccessfulJSONResponse(forEndpoint: "/articles/AD541L009-G11") { json in
            expect(try! json.getString(at: "units", 0, "id")) == "AD541L009-G11000S000"
        }
    }

    func testAuthorizeEndpoint() {
        assertSuccessfulResponse(forEndpoint: "/oauth2/authorize") { data in
            if let html = String(data: data, encoding: .utf8) {
                expect(html).to(contain("value=\"qux-quux-corge\""))
            }
        }
    }

    fileprivate func assertSuccessfulJSONResponse(forEndpoint endpoint: String, completion: JSONCompletion? = nil) {
        assertSuccessfulResponse(forEndpoint: endpoint) { data in
            let json = try! JSON(data: data)
            expect(json).toNot(beNil())
            completion?(json)
        }
    }

    fileprivate func assertSuccessfulResponse(forEndpoint endpoint: String, completion: DataCompletion? = nil) {
        let expectation = self.expectation(description: "assertSuccessfulResponse \(endpoint)")
        let url = MockAPI.endpointURL(forPath: endpoint).absoluteString

        if let operation = try? HTTP.GET(url) {
            operation.start { response in
                completion?(response.data)
                expectation.fulfill()
            }

        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }

}
