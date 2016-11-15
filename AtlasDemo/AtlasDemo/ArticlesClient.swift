//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import AtlasSDK
import AtlasMockAPI
import SwiftHTTP

typealias ArticlesCompletion = AtlasAPIResult<[DemoArticle]> -> Void

enum ArticlesError: ErrorType {
    case NoData
    case Error(ErrorType)
}

// swiftlint:disable force_unwrapping

class ArticlesClient {

    var dataTask: NSURLSessionDataTask?

    func fetch(articlesForSKUs skus: [String], completion: ArticlesCompletion) {
        if let operation = try? HTTP.GET(endpointURL(forSKUs: skus)) {
            operation.start { response in
                if let error = response.error {
                    return completion(.failure(ArticlesError.Error(error)))
                }
                guard let responseString = response.text else {
                    return completion(.failure(ArticlesError.NoData))
                }
                let articles = DemoCatalog(jsonString: responseString).articles
                completion(.success(articles))
            }
        }
    }

    private func endpointURL(forSKUs skus: [String]) -> String {
        if AtlasMockAPI.hasMockedAPIStarted {
            return AtlasMockAPI.endpointURL(forPath: "/articles").absoluteString!
        }

        let urlComponents = NSURLComponents(string: "https://api.zalando.com/articles")!
        urlComponents.queryItems = skus.map {
            NSURLQueryItem(name: "articleId", value: $0)
        }

        return urlComponents.URL!.absoluteString!
    }

}
