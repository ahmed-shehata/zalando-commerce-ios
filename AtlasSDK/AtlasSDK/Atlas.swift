//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasConfigurationCompletion = AtlasResult<APIClient> -> Void

public struct Atlas {

    public static func configure(options: Options? = nil, bundle: NSBundle = NSBundle.mainBundle(),
        completion: AtlasConfigurationCompletion) {
            let options = options ?? Options(bundle: bundle)

            do {
                try options.validate()
            } catch let error {
                AtlasLogger.logError(error)
                completion(.failure(error))
                return
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

}
