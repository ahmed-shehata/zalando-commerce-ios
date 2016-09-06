//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

final class APIRequestBuildersContainer {

    private var requestBuilders = [APIRequestBuilder]()
    private let config: Config

    init(config: Config) {
        self.config = config
    }

    func createBuilder(forEndpoint endpoint: Endpoint,
        urlSession: NSURLSession = NSURLSession.sharedSession()) -> RequestBuilder {
            let builder = APIRequestBuilder(loginURL: config.loginURL, urlSession: urlSession, endpoint: endpoint)
            builder.executionFinished = {
                self.requestBuilders.remove($0)
            }
            requestBuilders.append(builder)
            return builder
    }

}
