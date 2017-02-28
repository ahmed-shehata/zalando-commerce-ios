//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICustomerTests: AtlasAPIClientBaseTests {

    let customerURL = URL(validURL: "https://atlas-sdk.api/api/customer")

    func testCreateCustomer() {
        let json: [String: Any] = ["customer_number": "12345678",
                                   "gender": "MALE",
                                   "email": "aaa@a.a",
                                   "first_name": "John",
                                   "last_name": "Doe"]
        let customerResponse = data(withJSONObject: json)
        let api = mockedAtlasAPI(forURL: customerURL, data: customerResponse, status: .ok)

        waitUntil(timeout: 60) { done in
            api.customer { result in
                defer { done() }
                guard case let .success(customer) = result else {
                    return fail("Should return Customer")
                }

                expect(customer.customerNumber) == "12345678"
                expect(customer.gender) == Gender.male
                expect(customer.email) == "aaa@a.a"
                expect(customer.firstName) == "John"
                expect(customer.lastName) == "Doe"
            }
        }
    }

}
