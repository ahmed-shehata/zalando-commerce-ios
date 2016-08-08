//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension Options {

    enum Environment: String {
        case staging = "staging"
        case production = "production"
    }

    enum ResponseFormat: String {
        case json = "json"
        case yaml = "yaml"
        case properties = "properties"
    }

    var environment: Environment {
        return self.useSandboxEnvironment ? .staging : .production

    }

    var configurationURL: NSURL {
        get {
            return configurationURL ?? configurationURL(inFormat: .json)
        }
        set {
            configurationURL = newValue
        }
    }

    @available( *, deprecated, message = "Should be moved to Atlas.configure()")
    private func configurationURL(inFormat format: ResponseFormat) -> NSURL {
        let urlComponents = NSURLComponents(validUrlString: "https://atlas-config-api.dc.zalan.do/api/config/")
        let basePath = (urlComponents.path ?? "/")

        urlComponents.path = "\(basePath)\(self.clientId)-\(environment).\(format)"
        return urlComponents.validURL
    }

}
