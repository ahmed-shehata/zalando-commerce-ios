//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias ConfigCompletion = AtlasResult<Config> -> Void

protocol Configurator {

    mutating func configure(completion: ConfigCompletion) -> Void

}

struct ConfigClient: Configurator {

    private let requestBuilder: RequestBuilder
    private let options: Options

    init(options: Options) {
        let endpoint = APIEndpoint(baseURL: options.configurationURL)
        self.options = options
        self.requestBuilder = RequestBuilder(endpoint: endpoint)
    }

    mutating func configure(completion: ConfigCompletion) {
        self.requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let config = Config(json: response.body, options: self.options) else {
                    completion(.failure(AtlasConfigurationError.incorrectConfigServiceResponse))
                    return
                }
                completion(.success(config))
            }
        }
    }

}
