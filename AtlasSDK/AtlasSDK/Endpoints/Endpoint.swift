//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

typealias EndpointParameters = [String: Any]
typealias EndpointHeaders = [String: Any]

protocol Endpoint: CustomStringConvertible {

    var method: HTTPMethod { get }

    var contentType: String { get }
    var acceptedContentType: String { get }

    var url: Foundation.URL { get }

    var queryItems: [URLQueryItem]? { get }
    var parameters: EndpointParameters? { get }
    var headers: EndpointHeaders? { get }

    var authorizationToken: String? { get }

}

extension Endpoint {

    var method: HTTPMethod { return .GET }

    var contentType: String { return "application/json" }
    var acceptedContentType: String { return "application/json" }

    var queryItems: [URLQueryItem]? { return nil }
    var parameters: EndpointParameters? { return nil }
    var headers: EndpointHeaders? { return nil }

    var authorizationToken: String? { return nil }

}

extension Endpoint {

    var description: String {
        let params = String(withJSONObject: parameters) ?? "<NO PARAMETERS>"

        return "\(method) \(url)\n"
            + "Content-Type: \(contentType)\n"
            + "Accepted: \(acceptedContentType)\n\n"
            + params
            + "\n"
    }

}
