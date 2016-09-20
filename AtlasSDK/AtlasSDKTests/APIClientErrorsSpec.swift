//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class APIClientErrorsSpec: APIClientBaseSpec {

    override func spec() {

        describe("API Client Errors") {

            let clientURL = NSURL(validURL: "https://atlas-sdk.api/api/any_endpoint")

            it("should return error on no data response") {
                let status = HTTPStatus.OK

                let client = self.mockedAPIClient(forURL: clientURL, data: nil, status: status)

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

            it("should return error on unauthenticated request") {
                let status = HTTPStatus.Unauthorized
                let json = ["type": "http://httpstatus.es/401", "title": "unauthorized",
                    "status": status.rawValue, "detail": "Full authentication is required to access this resource"]

                let errorResponse = self.dataWithJSONObject(json)
                let options = Options(clientId: "atlas_Y2M1MzA",
                    salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                    useSandbox: true,
                    countryCode: "DE",
                    interfaceLanguage: "de",
                    configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))

                let client = self.mockedAPIClient(forURL: clientURL, options: options, data: errorResponse, status: status)

                waitUntil(timeout: 10) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result else {
                            return fail("Should emit \(AtlasAPIError.unauthorized)")
                        }

                        expect("\(error)").to(equal("\(AtlasAPIError.unauthorized)"))
                    }
                }
            }

            it("should return error on backend error") {
                let status = HTTPStatus.Forbidden
                let json = ["type": "http://httpstatus.es/401", "title": "unauthorized",
                    "status": status.rawValue, "detail": ""]

                let errorResponse = self.dataWithJSONObject(json)
                let client = self.mockedAPIClient(forURL: clientURL, data: errorResponse, status: status)

                waitUntil(timeout: 10) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result,
                            AtlasAPIError.backend(let errorStatus, let title, let details) = error else {
                                return fail("Should emit AtlasAPIError.backend")
                        }

                        expect(errorStatus).to(equal(status.rawValue))
                        expect(title).to(equal(json["title"] as? String))
                        expect(details).to(equal(json["detail"] as? String))
                    }
                }
            }

            it("should return error when response has NSURLDomainError") {
                let client = self.mockedAPIClient(forURL: clientURL, data: nil,
                    status: HTTPStatus.Unauthorized, errorCode: NSURLErrorBadURL)

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

            it("should return error when response has mangled json") {
                let errorStatus = HTTPStatus.ServiceUnavailable
                let errorResponse = "Some text error".dataUsingEncoding(NSUTF8StringEncoding)

                let client = self.mockedAPIClient(forURL: clientURL, data: errorResponse, status: errorStatus)

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
    }

}