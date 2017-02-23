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
        waitUntilAtlasAPIClientIsConfigured { done, api in
            let sku = ConfigSKU(value: "AD541L009-G11")
            api.article(with: sku) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let article):
                    let selectedArticle = SelectedArticle(article: article, unitIndex: 0, desiredQuantity: 1)
                    api.createCheckoutCart(forSelectedArticle: selectedArticle) { result in
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
        waitUntilAtlasAPIClientIsConfigured { done, api in
            api.createCheckout(from: self.cartId) { result in
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
