//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasClientCompletion = AtlasResult<APIClient> -> Void

public struct Atlas {

    public static func configure(options: Options? = nil, completion: AtlasClientCompletion) {
        let options = options ?? Options()
        do {
            try options.validate()
        } catch let error {
            AtlasLogger.logError(error)
            return completion(.failure(error))
        }

        ConfigClient(options: options).configure { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError(error)
                completion(.failure(error))
            case .success(let config):
                let client = APIClient(config: config)
                completion(.success(client))
            }
        }
    }

    public static func isUserLoggedIn() -> Bool {
        return APIAccessToken.retrieve() != nil
    }

    public static func logoutUser() {
        APIAccessToken.delete()
    }

}
