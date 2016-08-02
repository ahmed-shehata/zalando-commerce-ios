//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol EndpointType {

    var baseURL: NSURL { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var acceptedContentType: String? { get }
    var path: String? { get }
    var queryItems: [NSURLQueryItem]? { get }
    var parameters: [String: AnyObject]? { get }

    var URL: NSURL { get }

}

extension EndpointType {

    var URL: NSURL {
        let urlComponents = NSURLComponents(validURL: baseURL)
        urlComponents.queryItems = self.queryItems
        if let path = self.path {
            return urlComponents.validURL.URLByAppendingPathComponent(path)
        } else {
            return urlComponents.validURL
        }
    }

}
