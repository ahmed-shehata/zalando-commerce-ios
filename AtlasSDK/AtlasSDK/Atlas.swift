//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasClientCompletion = AtlasResult<APIClient> -> Void

public struct Atlas {

    public static func configure(bundle: NSBundle = NSBundle.mainBundle(), completion: AtlasClientCompletion) {
        let options = Options(bundle: bundle)
        configure(options) { result in
            completion(result)
        }
    }

    public static func configure(options: Options, completion: AtlasClientCompletion) {
        do {
            try options.validate()
        } catch let error {
            AtlasLogger.logError(error)
            return completion(.failure(error))
        }

        var configurator = ConfigClient(options: options)
        configurator.configure { result in
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
