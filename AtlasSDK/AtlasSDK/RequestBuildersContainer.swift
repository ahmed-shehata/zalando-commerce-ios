//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

@available( *, deprecated, message = "Rename, make it better, or just drop it")
final class RequestBuildersContainer {

    private var requestBuilders = [RequestBuilder]()

    func createBuilder(forEndpoint endpoint: Endpoint, urlSession: NSURLSession = NSURLSession.sharedSession()) -> RequestBuilder {
        let builder = RequestBuilder(urlSession: urlSession, endpoint: endpoint)
        builder.executionFinished = { builder in
            self.requestBuilders.remove(builder)
        }
        requestBuilders.append(builder)
        return builder
    }

}
