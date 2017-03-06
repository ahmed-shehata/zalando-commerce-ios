//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 Provides all functional API calls with their business logic.
 Main entry point for the AtlasSDK framework.

 - Note: If not specified otherwise – all API calls require user to be
     logged in and accepted a consent. Otherwise `Result.failure` with
     `APIError.unauthorized` is returned.
 */
public struct AtlasAPI {

    /// Configuration of a client handling API calls
    public let config: Config

    let client: APIClient

    init(config: Config, session: URLSession = .shared) {
        self.client = APIClient(config: config, session: session)
        self.config = config
    }

}
