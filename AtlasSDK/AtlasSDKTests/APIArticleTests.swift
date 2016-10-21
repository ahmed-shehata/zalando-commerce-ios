//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIArticleTests: APIClientBaseTests {

    func testFetchArticle() {
        waitUntilAPIClientIsConfigured { done, client in
            let sku = "AD541L009-G11"
            client.article(forSKU: sku) { result in
                switch result {
                case .failure(let error):
                    fail(String(error))
                case .success(let article):
                    expect(article.id).to(equal(sku))
                    expect(article.name).to(equal("ADIZERO  - Sportkleid - red"))
                    expect(article.brand.name).to(equal("adidas Performance"))

                    expect(article.availableUnits.count).to(equal(1))
                    expect(article.availableUnits.first?.id).to(equal("AD541L009-G1100XS000"))
                    expect(article.availableUnits.first?.price.amount).to(equal(76.45))

                    let validUrl = "https://i6.ztat.net/detail/AD/54/1L/00/9G/11/AD541L009-G11@14.jpg"
                    expect(article.media.images.first?.detailURL).to(equal(NSURL(validURL: validUrl)))
                    expect(article.media.images.first?.order).to(equal(1))
                }
                done()
            }
        }
    }

}
