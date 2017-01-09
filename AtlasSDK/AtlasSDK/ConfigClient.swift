//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasConfigCompletion = (AtlasAPIResult<Config>) -> Void

protocol Configurator {

    func configure(completion: @escaping AtlasConfigCompletion) -> Void

}

struct ConfigClient: Configurator {

    fileprivate let options: Options

    init(options: Options) {
        self.options = options
    }

    func configure(completion: @escaping AtlasConfigCompletion) {
        let requestBuilder = RequestBuilder(forEndpoint: GetConfigEndpoint(url: options.configurationURL))
        var apiRequest = APIRequest<Config>(requestBuilder: requestBuilder) { response in
            guard let json = response.body, let config = Config(json: json, options: self.options) else { return nil }
            return config
        }
        apiRequest.execute(completion)
    }

}
