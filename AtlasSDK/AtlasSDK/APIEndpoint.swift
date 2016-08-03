//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct APIEndpoint: EndpointType {

    let baseURL: NSURL

    let method: HTTPMethod
    let contentType: String

    let acceptedContentType: String?
    let path: String?
    let queryItems: [NSURLQueryItem]?
    let parameters: [String: AnyObject]?

    init(baseURL: NSURL,
        method: HTTPMethod = .GET,
        contentType: String = "application/json",
        acceptedContentType: String? = nil,
        path: String? = nil,
        queryItems: [NSURLQueryItem]? = nil,
        parameters: [String: AnyObject]? = nil) {
            self.baseURL = baseURL

            self.method = method
            self.contentType = contentType

            self.acceptedContentType = acceptedContentType
            self.path = path
            self.queryItems = queryItems
            self.parameters = parameters
    }

}
