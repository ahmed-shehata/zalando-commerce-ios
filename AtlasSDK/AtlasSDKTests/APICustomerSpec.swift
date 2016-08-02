//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AtlasSDK

class APICustomerSpec: QuickSpec {

    // swiftlint:disable:next line_length
    private let atlas = AtlasSDK(options: Options(clientId: "clientId", salesChannel: "SALES_CHANNEL", useSandbox: true))

    override func spec() { // swiftlint:disable:this function_body_length

        describe("Customer API") {

            guard let customerUrl = NSURL(string: "https://atlas-sdk.api/api/customer")
            else { fail("Cannot initialize customerUrl"); return }

            it("should make successful request") {
                do {
                    let customerResponse = try NSJSONSerialization.dataWithJSONObject([
                        "customer_number": "12345678",
                        "gender": "MALE",
                        "email": "aaa@a.a",
                        "first_name": "John",
                        "last_name": "Doe"
                        ], options: [])

                    self.atlas.apiClient?.urlSession = URLSessionMock(data: customerResponse,
                        response: NSHTTPURLResponse(URL: customerUrl, statusCode: 200),
                        error: nil)
                    self.atlas.apiClient?.customer { result in
                        switch result {
                        case .failure: break
                        case .success(let customer):
                            expect(customer.customerNumber).to(equal("12345678"))
                            expect(customer.gender).to(equal(Customer.Gender.Male))
                            expect(customer.email).to(equal("aaa@a.a"))
                            expect(customer.firstName).to(equal("John"))
                            expect(customer.lastName).to(equal("Doe"))
                        }
                    }
                } catch { fail("Cannot create NSData from json") }
            }

            it("should return error when request is unsuccessful") {
                let json = [
                    "type": "http://httpstatus.es/401",
                    "title": "unauthorized",
                    "status": 401,
                    "detail": "Full authentication is required to access this resource"
                ]

                do {
                    let errorResponse = try NSJSONSerialization.dataWithJSONObject(json, options: [])

                    self.atlas.apiClient?.urlSession = URLSessionMock(data: errorResponse,
                        response: NSHTTPURLResponse(URL: customerUrl,
                            statusCode: 401), error: nil)

                    self.atlas.apiClient?.customer { result in
                        switch result {
                        case .failure(let error as AtlasAPIError):
                            expect(error.message).to(equal(json["title"]))
                            expect(error.code).to(equal(json["status"]))
                            expect(error.extraDetails).to(equal(json["detail"]))
                        default:
                            fail("Should emit AtlasAPIError")
                        }
                    }
                } catch { fail("Cannot create NSData from json") }
            }

            it("should return error when response has NSURLDomainError") {
                let sessionMock = URLSessionMock(data: nil,
                    response: NSHTTPURLResponse(URL: customerUrl, statusCode: 401),
                    error: NSError(domain: "NSURLErrorDomain", code: NSURLErrorBadURL, userInfo: nil))

                self.atlas.apiClient?.urlSession = sessionMock

                self.atlas.apiClient?.customer { result in
                    switch result {
                    case .failure(let error as HTTPError):
                        expect(error.code).to(equal(NSURLErrorBadURL))
                        expect(error.message).to(contain("The operation couldn’t be completed"))
                    default:
                        fail("Should emit HTTPError")
                    }
                }
            }

        }
    }
}
