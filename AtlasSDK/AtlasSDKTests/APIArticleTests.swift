//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class APIArticleTests: AtlasAPIClientBaseTests {

    func testFetchArticle() {
        waitUntilAtlasAPIClientIsConfigured { done, client in
            let sku = "AD541L009-G11"
            client.article(withSKU: sku) { result in
                switch result {
                case .failure(let error):
                    fail(String(describing: error))
                case .success(let article):
                    expect(article.id) == sku
                    expect(article.name) == "ADIZERO  - Sportkleid - red"
                    expect(article.brand.name) == "adidas Performance"

                    expect(article.availableUnits.count) == 1
                    expect(article.availableUnits.first?.id) == "AD541L009-G1100XS000"
                    expect(article.availableUnits.first?.price.amount) == 10.45

                    let validURL = "https://i6.ztat.net/detail/AD/54/1L/00/9G/11/AD541L009-G11@14.jpg"
                    expect(article.media?.mediaItems.first?.detailURL) == URL(validURL: validURL)
                    expect(article.media?.mediaItems.first?.order) == 1
                }
                done()
            }
        }
    }

}
