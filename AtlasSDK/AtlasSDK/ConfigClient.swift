//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasConfigCompletion = AtlasResult<Config> -> Void

protocol Configurator {

    mutating func configure(completion: AtlasConfigCompletion) -> Void

}

struct ConfigClient: Configurator {

    private var requestBuilder: RequestBuilder
    private let options: Options

    init(options: Options) {
        let endpoint = GetConfigEndpoint(URL: options.configurationURL)
        self.options = options
        self.requestBuilder = RequestBuilder(endpoint: endpoint)
    }

    mutating func configure(completion: AtlasConfigCompletion) {
        self.requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let json = response.body, config = Config(json: json, options: self.options) else {
                    return completion(.failure(AtlasConfigurationError.incorrectConfigServiceResponse))
                }
                completion(.success(config))
            }
        }
    }

}
