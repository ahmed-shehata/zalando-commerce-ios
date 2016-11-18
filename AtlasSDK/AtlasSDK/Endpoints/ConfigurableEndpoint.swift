//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol ConfigurableEndpoint: Endpoint {

    var serviceURL: Foundation.URL { get }
    var path: String { get }

}

extension ConfigurableEndpoint {

    var url: URL {
        var urlComponents = URLComponents(validUrl: serviceURL)
        urlComponents.queryItems = self.queryItems
        return urlComponents.validUrl.appendingPathComponent(path)
    }

}
