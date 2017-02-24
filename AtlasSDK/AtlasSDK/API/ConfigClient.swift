//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

struct ConfigClient {

    fileprivate let options: Options

    init(options: Options) {
        self.options = options
    }

    func configure(completion: @escaping APIResultCompletion<Config>) {
        let requestBuilder = RequestBuilder(forEndpoint: GetConfigEndpoint(url: options.configurationURL))
        var apiRequest = APIRequest<Config>(requestBuilder: requestBuilder) { response in
            guard let json = response.body, let config = Config(json: json, options: self.options) else { return nil }
            return config
        }
        apiRequest.execute(append: completion)
    }

}
