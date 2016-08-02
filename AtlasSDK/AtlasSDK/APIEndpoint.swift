//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct APIEndpoint: EndpointType {

    public let baseURL: NSURL

    public let method: HTTPMethod
    public let contentType: String

    public let acceptedContentType: String?
    public let path: String?
    public let queryItems: [NSURLQueryItem]?
    public let parameters: [String: AnyObject]?

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
