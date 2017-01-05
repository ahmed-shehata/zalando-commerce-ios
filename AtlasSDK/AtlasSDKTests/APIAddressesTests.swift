//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIAddressesTests: AtlasAPIClientBaseTests {

    func testFetchAddressObject() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            client.addresses { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let addresses):
                    expect(addresses.first?.id) == "6702759"
                    expect(addresses.first?.customerNumber) == "3036553496"
                    expect(addresses.first?.gender) == Gender.female
                    expect(addresses.first?.firstName) == "Erika"
                    expect(addresses.first?.lastName) == "Mustermann"
                    expect(addresses.first?.street) == "Mollstr. 1"
                    expect(addresses.first?.additional) == "EG"
                    expect(addresses.first?.zip) == "10178"
                    expect(addresses.first?.city) == "Berlin"
                    expect(addresses.first?.countryCode) == "DE"
                    expect(addresses.first?.isDefaultBilling).to(beTrue())
                    expect(addresses.first?.isDefaultShipping).to(beTrue())
                }
                done()
            }
        }
    }

    func testDeleteAddress() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            client.deleteAddress(withId: "6702748") { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let emptyResponse):
                    expect(emptyResponse).notTo(beNil())
                }
                done()
            }
        }
    }

}
