//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/// Main entry point for the framework
///
/// - Note: See [project structure](https://github.com/zalando-incubator/atlas-ios/wiki/Project-structure)
public struct Atlas {

    /// Configures and returns network client based on given options
    ///
    /// - Parameters:
    ///   - options:
    ///   - completion: Fired when network configuration call is finished. 
    /// - SeeAlso: `Options`, `AtlasClientCompletion`
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
