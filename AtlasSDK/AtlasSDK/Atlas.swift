//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasClientCompletion = (AtlasResult<AtlasAPIClient>) -> Void

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

    public static func authorize(withToken token: String) {
        APIAccessToken.store(token: token)
    }

    public static func isAuthorized() -> Bool {
        return APIAccessToken.retrieve() != nil
    }

    public static func deauthorize() {
        APIAccessToken.delete()
    }

}
