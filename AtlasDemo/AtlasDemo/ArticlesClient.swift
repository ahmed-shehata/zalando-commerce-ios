//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import AtlasSDK
import AtlasMockAPI
import SwiftHTTP

typealias ArticlesCompletion = (AtlasResult<[DemoArticle]>) -> Void

enum ArticlesError: Error {
    case noData
    case error(Error)
}

// swiftlint:disable force_unwrapping

class ArticlesClient {

    var dataTask: URLSessionDataTask?

    func fetch(articlesForSKUs skus: [String], completion: @escaping ArticlesCompletion) {
        if let operation = try? HTTP.GET(endpointURL(forSKUs: skus)) {
            operation.start { response in
                if let error = response.error {
                    return completion(.failure(ArticlesError.error(error)))
                }
                guard let responseString = response.text else {
                    return completion(.failure(ArticlesError.noData))
                }
                let articles = DemoCatalog(jsonString: responseString).articles
                completion(.success(articles))
            }
        }
    }

    fileprivate func endpointURL(forSKUs skus: [String]) -> String {
        if AtlasMockAPI.hasMockedAPIStarted {
            return AtlasMockAPI.endpointURL(forPath: "/articles").absoluteString
        }

        var urlComponents = URLComponents(string: "https://api.zalando.com/articles")!
        urlComponents.queryItems = skus.map {
            URLQueryItem(name: "articleId", value: $0)
        }

        return urlComponents.url!.absoluteString
    }

}
