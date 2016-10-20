//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
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
                        case .success(let addresses):
                            expect(addresses.first?.id).to(equal("6702759"))
                            expect(addresses.first?.customerNumber).to(equal("3036553496"))
                            expect(addresses.first?.gender).to(equal(Gender.female))
                            expect(addresses.first?.firstName).to(equal("Erika"))
                            expect(addresses.first?.lastName).to(equal("Mustermann"))
                            expect(addresses.first?.street).to(equal("Mollstr. 1"))
                            expect(addresses.first?.additional).to(equal("EG"))
                            expect(addresses.first?.zip).to(equal("10178"))
                            expect(addresses.first?.city).to(equal("Berlin"))
                            expect(addresses.first?.countryCode).to(equal("DE"))
                            expect(addresses.first?.isDefaultBilling).to(beTrue())
                            expect(addresses.first?.isDefaultShipping).to(beTrue())
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
