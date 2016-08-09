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

    func createBuilder(forEndpoint endpoint: EndpointType) -> RequestBuilder {
        let builder = APIRequestBuilder(loginURL: self.config.loginURL, endpoint: endpoint)
        builder.executionFinished = {
            self.requestBuilders.remove($0)
        }
        requestBuilders.append(builder)
        return builder
    }

}
