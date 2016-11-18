//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasAPIClientErrorsTests: AtlasAPIClientBaseTests {

    let clientURL = URL(validUrl: "https://atlas-sdk.api/api/any_endpoint")

    func testNoDataResponse() {
        let status = HTTPStatus.ok
        let client = mockedAtlasAPIClient(forURL: clientURL, data: nil, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error, _) = result else {
                    return fail("Should emit \(AtlasAPIError.noData)")
                }

                expect("\(error)").to(equal("\(AtlasAPIError.noData)"))
            }
        }
    }

    func testUnauthenticatedRequest() {
        let status = HTTPStatus.unauthorized
        let json: [String: Any] = ["type": "http://httpstatus.es/401",
            "title": "unauthorized",
            "status": status.rawValue,
            "detail": "Full authentication is required to access this resource"]

        let errorResponse = data(withJSONObject: json as AnyObject)
        let options = Options(clientId: "atlas_Y2M1MzA",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              useSandbox: true,
                              interfaceLanguage: "de",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        let client = mockedAtlasAPIClient(forURL: clientURL, options: options, data: errorResponse, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                switch result {
                case .failure(let error, _):
                    switch error {
                    case AtlasAPIError.unauthorized: break
                    default: fail("\(error) should be unauthorized")
                    }
                default: fail("\(result) should be failure")
                }
            }
        }
    }

    func testBackendError() {
        let status = HTTPStatus.forbidden
        let json: [String: Any] = ["type": "http://httpstatus.es/401", "title": "unauthorized",
            "status": status.rawValue, "detail": ""]

        let errorResponse = data(withJSONObject: json as AnyObject)
        let client = mockedAtlasAPIClient(forURL: clientURL, data: errorResponse, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error, _) = result,
                    case let AtlasAPIError.backend(errorStatus, type, title, details) = error else {
                        return fail("Should emit AtlasAPIError.backend")
                }

                expect(errorStatus).to(equal(status.rawValue))
                expect(type).to(equal(json["type"] as? String))
                expect(title).to(equal(json["title"] as? String))
                expect(details).to(equal(json["detail"] as? String))
            }
        }
    }

    func testNSURLDomainError() {
        let client = mockedAtlasAPIClient(forURL: clientURL,
                                          data: nil,
                                          status: .unauthorized,
                                          errorCode: NSURLErrorBadURL)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error, _) = result,
                    case let AtlasAPIError.nsURLError(code, details) = error else {
                        return fail("Should emit AtlasAPIError.nsURLError")
                }

                expect(code).to(equal(NSURLErrorBadURL))
                expect(details).to(contain("The operation couldn’t be completed"))
            }
        }
    }

    func testMangledJSON() {
        let errorStatus = HTTPStatus.serviceUnavailable
        let errorResponse = "Some text error".data(using: String.Encoding.utf8)
        let client = mockedAtlasAPIClient(forURL: clientURL, data: errorResponse, status: errorStatus)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error, _) = result,
                    case let AtlasAPIError.http(status, _) = error else {
                        return fail("Should emit AtlasAPIError.http")
                }

                expect(status).to(equal(errorStatus))
            }
        }
    }

}
