//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

// TODO: Rename or even make it better
final class APIRequestBuildersContainer {

    private var requestBuilders = [RequestBuilder]()
    private let authorizationHandler: AtlasAuthorizationHandler?

    init(config: Config) {
        self.authorizationHandler = config.authorizationHandler
    }

    func createBuilder(forEndpoint endpoint: Endpoint, urlSession: NSURLSession = NSURLSession.sharedSession()) -> RequestBuilder {
        var builder = RequestBuilder(urlSession: urlSession, endpoint: endpoint)
        builder.authorizationHandler = self.authorizationHandler
        builder.executionFinished = { builder in
            self.requestBuilders.remove(builder)
        }
        requestBuilders.append(builder)
        return builder
    }
    
}
