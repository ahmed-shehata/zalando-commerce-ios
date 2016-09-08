//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class APIAddressesSpec: APIClientBaseSpec {

    override func spec() {

        describe("Addresses") {

            it("should fetch address object successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    client.addresses { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let addressList):
                            expect(addressList.addresses.first?.id).to(equal("6702759"))
                            expect(addressList.addresses.first?.customerNumber).to(equal("3036553496"))
                            expect(addressList.addresses.first?.gender).to(equal(Gender.female))
                            expect(addressList.addresses.first?.firstName).to(equal("Erika"))
                            expect(addressList.addresses.first?.lastName).to(equal("Mustermann"))
                            expect(addressList.addresses.first?.street).to(equal("Mollstr. 1"))
                            expect(addressList.addresses.first?.additional).to(equal("EG"))
                            expect(addressList.addresses.first?.zip).to(equal("10178"))
                            expect(addressList.addresses.first?.city).to(equal("Berlin"))
                            expect(addressList.addresses.first?.countryCode).to(equal("DE"))
                            expect(addressList.addresses.first?.isDefaultBilling).to(beTrue())
                            expect(addressList.addresses.first?.isDefaultShipping).to(beTrue())
                            expect(addressList.addresses.first?.fullContactPostalAddress).to(equal("Erika Mustermann, Mollstr. 1\n10178 Berlin\n"))
                        }
                        done()
                    }
                }
            }

            it("should delete address successfully") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    client.deleteAddress("6702748") { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let emptyResponse):
                            expect(emptyResponse).notTo(beNil())
                        }
                        done()
                    }
                }
            }

        }

    }

}
