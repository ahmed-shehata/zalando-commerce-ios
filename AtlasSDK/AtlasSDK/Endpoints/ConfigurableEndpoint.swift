//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol ConfigurableEndpoint: Endpoint {

    var serviceURL: NSURL { get }
    var path: String { get }

}

extension ConfigurableEndpoint {

    var URL: NSURL {
        let urlComponents = NSURLComponents(validURL: serviceURL)
        urlComponents.queryItems = self.queryItems
        #if swift(>=2.3)
            return urlComponents.validURL.URLByAppendingPathComponent(path)! // swiftlint:disable:this force_unwrapping
        #else
            return urlComponents.validURL.URLByAppendingPathComponent(path)
        #endif
    }

}
