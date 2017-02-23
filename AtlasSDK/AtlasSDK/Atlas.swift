//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/// Main entry point for the AtlasSDK framework
///
/// Does not keep any state internally.
///
/// - Note: See [project structure](https://github.com/zalando-incubator/atlas-ios/wiki/Project-structure)
public struct Atlas {

    /// Configures and returns network client based on given options
    ///
    /// - Parameters:
    ///   - options: Options for the client to be created. When `nil`, `$INFOPLIST_FILE` file of the app is used as configuration. See [Configuration](https://github.com/zalando-incubator/atlas-ios/wiki/Configuration#via-infoplist)
    ///   - completion: Fired when network configuration call is finished. Containts `AtlasResult.success` with `AtlasAPIClient` or `AtlasResult.failure` with `Error` reason.
    public static func configure(options: Options? = nil, completion: @escaping AtlasClientCompletion) {
        let options = options ?? Options()
        do {
            try options.validate()
        } catch let error {
            AtlasLogger.logError(error)
            return completion(.failure(error))
        }

        ConfigClient(options: options).configure { result in
            switch result {
            case .failure(let error, _):
                AtlasLogger.logError(error)
                completion(.failure(error))
            case .success(let config):
                let client = AtlasAPIClient(config: config)
                completion(.success(client))
            }
        }
    }

}
