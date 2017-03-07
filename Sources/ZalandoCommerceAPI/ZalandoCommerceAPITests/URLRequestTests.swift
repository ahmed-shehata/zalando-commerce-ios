//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceAPI

class URLRequestTests: APITestCase {

    func testUserAgentHeader() {
        let endpoint = GetConfigEndpoint(url: TestConsts.configURL)
        let request = try? URLRequest(endpoint: endpoint)

        let sdkBundle = Bundle(for: RFC3339DateFormatter.self)
        let sdkId = sdkBundle.version

        let appBundle = Bundle.main
        let appId = appBundle.version

        let expectedVersion = [appId, sdkId, SystemInfo.platform].joined(separator: ", ")
        expect(request?.allHTTPHeaderFields?["User-Agent"]) == expectedVersion
    }

    func testLanguageHeader() {
        let language = "fr"
        let request = URLRequest(url: URL(validURL: "http://zalando.de"), language: language)

        expect(request.allHTTPHeaderFields?["Accept-Language"]).to(contain("\(language);q=1.0"))
    }

    func testLanguageQueryString() {
        let language = "fr"
        let request = URLRequest(url: URL(validURL: "http://zalando.de"), language: language)

        let urlComponents = URLComponents(validURL: request.url!)
        expect(urlComponents.queryItems).to(contain(URLQueryItem(name: "lng", value: language)))
    }

    func testSalesChannelLanguageHeader() {
        let clientURL = URL(validURL: "https://atlas-sdk.api/api/any_endpoint")
        let api = mockedAPI(forURL: clientURL, data: nil, status: .ok)
        let language = api.config.salesChannel.languageCode
        let request = URLRequest(url: URL(validURL: "http://zalando.de"), language: language)

        expect(request.allHTTPHeaderFields?["Accept-Language"]).to(contain("\(language);q=1.0"))
    }

}
