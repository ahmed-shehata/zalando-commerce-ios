//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class APICreateCheckoutSpec: APIClientBaseSpec {

    private let addressId = "6702759"

    override func spec() {

        describe("Create checkout") {

            it("should create checkout from article") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    let sku = "AD541L009-G11"
                    client.article(forSKU: sku) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let article):
                            let selectedArticleUnit = SelectedArticleUnit(article: article, selectedUnitIndex: 0)
                            client.createCheckoutCart(for: selectedArticleUnit) { result in
                                switch result {
                                case .failure(let error):
                                    fail(String(error))
                                case .success(let result):
                                    expect(result.checkout.id).to(equal(self.checkoutId))
                                }
                                done()
                            }
                        }
                    }
                }
            }

            it("should create checkout from cart") {
                self.waitUntilAPIClientIsConfigured { done, client in
                    client.createCheckout(self.cartId) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let checkout):
                            expect(checkout.id).to(equal(self.checkoutId))
                        }
                        done()
                    }
                }
            }

        }
    }

}
