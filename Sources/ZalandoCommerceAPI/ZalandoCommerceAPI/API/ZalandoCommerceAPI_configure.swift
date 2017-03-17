//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension ZalandoCommerceAPI {

    /**
     Configures and returns API client based on given options.
     
     When neither `Options` are passed or correct, nor `$INFOPLIST_FILE` contains required
     keys and values – `completion` retuns `Result.failure` with error returned from
     `Options.validate()`

     - Note: See [configuration](https://github.com/zalando-incubator/zalando-commerce-ios/wiki/Configuration)
     and [project structure](https://github.com/zalando-incubator/zalando-commerce-ios/wiki/Project-structure)

     - Parameters:
         - options: Options for API client to be created. When `nil`, `$INFOPLIST_FILE` file of the app is used as configuration.
         - completion: Fired when network configuration call is finished.
            Contains `Result.success` with `ZalandoCommerceAPI` or `Result.failure` with `Error` reason.
     */
    public static func configure(options: Options? = nil, completion: @escaping ResultCompletion<ZalandoCommerceAPI>) {
        let options = options ?? Options()
        do {
            try options.validate()
        } catch let error {
            Logger.error(error)
            return completion(.failure(error))
        }

        ConfigClient(options: options).configure { result in
            switch result {
            case .failure(let error, _):
                Logger.error(error)
                completion(.failure(error))
            case .success(let config):
                let api = ZalandoCommerceAPI(config: config)
                completion(.success(api))
            }
        }
    }

}
