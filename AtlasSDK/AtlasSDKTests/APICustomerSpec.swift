//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class APICustomerSpec: APIClientBaseSpec {

    override func spec() {

        describe("Customer API") {

            let customerUrl = NSURL(validUrl: "https://atlas-sdk.api/api/customer")

            it("should make successful request") {
                let json = ["customer_number": "12345678", "gender": "MALE", "email": "aaa@a.a",
                    "first_name": "John", "last_name": "Doe"]
                let customerResponse = self.dataWithJSONObject(json)
                let client = self.mockedAPIClient(forURL: customerUrl, data: customerResponse, statusCode: 200)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .success(customer) = result else {
                            fail("Should return Customer")
                            return
                        }

                        expect(customer.customerNumber).to(equal("12345678"))
                        expect(customer.gender).to(equal(Customer.Gender.Male))
                        expect(customer.email).to(equal("aaa@a.a"))
                        expect(customer.firstName).to(equal("John"))
                        expect(customer.lastName).to(equal("Doe"))
                    }
                }
            }

            it("should return error on unauthenticated request") {
                let json = ["type": "http://httpstatus.es/401", "title": "unauthorized",
                    "status": 401, "detail": "Full authentication is required to access this resource"]

                let errorResponse = self.dataWithJSONObject(json)
                let client = self.mockedAPIClient(forURL: customerUrl, data: errorResponse, statusCode: 401)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result else {
                            fail("Should emit AtlasAPIError.Unauthorized")
                            return
                        }

                        expect("\(error)").to(equal("\(AtlasAPIError.Unauthorized)"))
                    }
                }
            }

            it("should return error on backend error") {
                let statusCode = HTTPStatus.Forbidden
                let json = ["type": "http://httpstatus.es/401", "title": "unauthorized",
                    "status": statusCode.rawValue, "detail": ""]

                let errorResponse = self.dataWithJSONObject(json)
                let client = self.mockedAPIClient(forURL: customerUrl, data: errorResponse, statusCode: statusCode.rawValue)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result,
                            AtlasAPIError.Backend(let status, let title, let details) = error else {
                                fail("Should emit AtlasAPIError.Backend")
                                return
                        }

                        expect(status).to(equal(statusCode.rawValue))
                        expect(title).to(equal(json["title"] as? String))
                        expect(details).to(equal(json["detail"] as? String))
                    }
                }
            }

            it("should return error when response has NSURLDomainError") {
                let client = self.mockedAPIClient(forURL: customerUrl, data: nil, statusCode: 401, errorCode: NSURLErrorBadURL)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result,
                            AtlasAPIError.NSURLError(let code, let details) = error else {
                                fail("Should emit NSURLError")
                                return
                        }

                        expect(code).to(equal(NSURLErrorBadURL))
                        expect(details).to(contain("The operation couldn’t be completed"))
                    }
                }
            }

            it("should return error when response has mangled json") {
                let errorStatus = HTTPStatus.ServiceUnavailable
                let errorResponse = "Some text error".dataUsingEncoding(NSUTF8StringEncoding)

                let client = self.mockedAPIClient(forURL: customerUrl, data: errorResponse, statusCode: errorStatus.rawValue)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        defer { done() }
                        guard case let .failure(error) = result,
                            AtlasAPIError.HTTP(let status, _) = error else {
                                fail("Should emit AtlasAPIError.HTTP")
                                return
                        }

                        expect(status).to(equal(errorStatus))
                    }
                }
            }

        }
    }
}
