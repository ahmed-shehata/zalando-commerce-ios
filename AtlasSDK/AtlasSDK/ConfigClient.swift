//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasConfigCompletion = AtlasAPIResult<Config> -> Void

protocol Configurator {

    func configure(completion: AtlasConfigCompletion) -> Void

}

struct ConfigClient: Configurator {

    private let options: Options

    init(options: Options) {
        self.options = options
    }

    func configure(completion: AtlasConfigCompletion) {
        let requestBuilder = RequestBuilder(forEndpoint: GetConfigEndpoint(URL: options.configurationURL))
        var apiRequest = APIRequest<Config>(requestBuilder: requestBuilder, successHandler: { response in
            guard let json = response.body, config = Config(json: json, options: self.options) else { return nil }
            return config
        }, completion: completion)
        apiRequest.execute()
    }

}
