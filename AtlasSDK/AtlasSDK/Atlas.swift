//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasClientCompletion = (AtlasResult<AtlasAPIClient>) -> Void

extension NSNotification.Name {

    public static let AtlasAuthorized = NSNotification.Name(rawValue: "Atlas.NotificationAuthorized")
    public static let AtlasDeauthorized = NSNotification.Name(rawValue: "Atlas.NotificationDeauthorized")
    public static let AtlasAuthorizationChanged = NSNotification.Name(rawValue: "Atlas.NotificationAuthorizationChanged")

}

public struct Atlas {

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
