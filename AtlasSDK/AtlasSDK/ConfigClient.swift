//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasConfigCompletion = AtlasResult<Config> -> Void

protocol Configurator {

    func configure(completion: AtlasConfigCompletion) -> Void

}

struct ConfigClient: Configurator {

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func configure(completion: AtlasConfigCompletion) {
        var requestBuilder = RequestBuilder(forEndpoint: GetConfigEndpoint(URL: options.configurationURL))
        requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.failure(error))
                }
            case .success(let response):
                guard let json = response.body, config = Config(json: json, options: self.options) else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.failure(AtlasConfigurationError.incorrectConfigServiceResponse))
                    }
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.success(config))
                }
            }
        }
    }

}
