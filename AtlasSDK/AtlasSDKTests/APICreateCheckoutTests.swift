//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APICreateCheckoutTests: AtlasAPIClientBaseTests {

    fileprivate let addressId = "6702759"

    func testCreateCheckoutFromArticle() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let sku = "AD541L009-G11"
            client.article(withSKU: sku) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let article):
                    let selectedArticle = SelectedArticle(article: article, unitIndex: 0, quantity: 1)
                    client.createCheckoutCart(forSKU: selectedArticle.sku) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(describing: error))
                        case .success(let result):
                            expect(result.checkout.id) == self.checkoutId
                        }
                        done()
                    }
                }
            }
        }
    }

    func testCreateCheckoutFromCart() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            client.createCheckout(fromCardId: self.cartId) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let checkout):
                    expect(checkout.id) == self.checkoutId
                }
                done()
            }
        }
    }

}
