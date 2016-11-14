//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasAPIClientErrorsTests: AtlasAPIClientBaseTests {

    let clientURL = NSURL(validURL: "https://atlas-sdk.api/api/any_endpoint")

    func testNoDataResponse() {
        let status = HTTPStatus.OK
        let client = mockedAtlasAPIClient(forURL: clientURL, data: nil, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error) = result else {
                    return fail("Should emit \(AtlasAPIError.noData)")
                }

                expect("\(error)").to(equal("\(AtlasAPIError.noData)"))
            }
        }
    }

    func testUnauthenticatedRequest() {
        let status = HTTPStatus.Unauthorized
        let json = ["type": "http://httpstatus.es/401",
                    "title": "unauthorized",
                    "status": status.rawValue,
                    "detail": "Full authentication is required to access this resource"]

        let errorResponse = dataWithJSONObject(json)
        let options = Options(clientId: "atlas_Y2M1MzA",
                              salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                              useSandbox: true,
                              interfaceLanguage: "de",
                              configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

        let client = mockedAtlasAPIClient(forURL: clientURL, options: options, data: errorResponse, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error) = result else {
                    return fail("Should emit \(AtlasAPIError.unauthorized)")
                }

                switch error {
                case AtlasAPIError.unauthorized: break
                default: fail("\(error) should be unauthorized")
                }
            }
        }
    }

    func testBackendError() {
        let status = HTTPStatus.Forbidden
        let json = ["type": "http://httpstatus.es/401", "title": "unauthorized",
                    "status": status.rawValue, "detail": ""]

        let errorResponse = dataWithJSONObject(json)
        let client = mockedAtlasAPIClient(forURL: clientURL, data: errorResponse, status: status)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error) = result,
                    AtlasAPIError.backend(let errorStatus, let type, let title, let details) = error else {
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
                                     status: .Unauthorized,
                                     errorCode: NSURLErrorBadURL)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error) = result,
                    AtlasAPIError.nsURLError(let code, let details) = error else {
                        return fail("Should emit AtlasAPIError.nsURLError")
                }

                expect(code).to(equal(NSURLErrorBadURL))
                expect(details).to(contain("The operation couldn’t be completed"))
            }
        }
    }

    func testMangledJSON() {
        let errorStatus = HTTPStatus.ServiceUnavailable
        let errorResponse = "Some text error".dataUsingEncoding(NSUTF8StringEncoding)
        let client = mockedAtlasAPIClient(forURL: clientURL, data: errorResponse, status: errorStatus)

        waitUntil(timeout: 10) { done in
            client.customer { result in
                defer { done() }
                guard case let .failure(error) = result,
                    AtlasAPIError.http(let status, _) = error else {
                        return fail("Should emit AtlasAPIError.http")
                }

                expect(status).to(equal(errorStatus))
            }
        }
    }

}
