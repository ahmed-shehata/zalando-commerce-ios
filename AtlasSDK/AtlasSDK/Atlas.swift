//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasClientCompletion = (AtlasResult<AtlasAPIClient>) -> Void

extension NSNotification.Name {

    /// Notification posted when a client got authorized
    public static let AtlasAuthorized = NSNotification.Name(rawValue: "Atlas.NotificationAuthorized")

    /// Notification posted when a client got unauthorized
    public static let AtlasDeauthorized = NSNotification.Name(rawValue: "Atlas.NotificationDeauthorized")

    /// Notification posted when a client authorization state has changed (follows `AtlasAuthorized` and `AtlasAuthorized`
    public static let AtlasAuthorizationChanged = NSNotification.Name(rawValue: "Atlas.NotificationAuthorizationChanged")

}


/// Main starting point for `AtlasSDK.framework`
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
