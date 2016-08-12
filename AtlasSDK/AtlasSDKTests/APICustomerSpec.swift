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
                        switch result {
                        case .success(let customer):
                            expect(customer.customerNumber).to(equal("12345678"))
                            expect(customer.gender).to(equal(Customer.Gender.Male))
                            expect(customer.email).to(equal("aaa@a.a"))
                            expect(customer.firstName).to(equal("John"))
                            expect(customer.lastName).to(equal("Doe"))
                        default:
                            fail("Should return Customer")
                        }
                        done()
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
                        switch result {
                        case .failure(let error as AtlasAPIError):
                            expect(error.message).to(equal(json["title"]))
                            expect(error.code).to(equal(json["status"]))
                            expect(error.extraDetails).to(equal(json["detail"]))
                        default:
                            fail("Should emit AtlasAPIError")
                        }
                        done()
                    }
                }
            }

            it("should return error when response has NSURLDomainError") {
                let client = self.mockedAPIClient(forURL: customerUrl, data: nil, statusCode: 401, errorCode: NSURLErrorBadURL)

                waitUntil(timeout: 60) { done in
                    client.customer { result in
                        switch result {
                        case .failure(let error as HTTPError):
                            expect(error.code).to(equal(NSURLErrorBadURL))
                            expect(error.message).to(contain("The operation couldn’t be completed"))
                        default:
                            fail("Should emit HTTPError")
                        }
                        done()
                    }
                }
            }

        }
    }
}
