//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICustomerTests: AtlasAPIClientBaseTests {

    let customerURL = URL(validUrl: "https://atlas-sdk.api/api/customer")

    func testCreateCustomer() {
        let json = ["customer_number": "12345678",
                    "gender": "MALE",
                    "email": "aaa@a.a",
                    "first_name": "John",
                    "last_name": "Doe"]
        let customerResponse = dataWithJSONObject(json)
        let client = mockedAtlasAPIClient(forURL: customerURL, data: customerResponse, status: .OK)

        waitUntil(timeout: 60) { done in
            client.customer { result in
                defer { done() }
                guard case let .success(customer) = result else {
                    return fail("Should return Customer")
                }

                expect(customer.customerNumber).to(equal("12345678"))
                expect(customer.gender).to(equal(Customer.Gender.Male))
                expect(customer.email).to(equal("aaa@a.a"))
                expect(customer.firstName).to(equal("John"))
                expect(customer.lastName).to(equal("Doe"))
            }
        }
    }

}
