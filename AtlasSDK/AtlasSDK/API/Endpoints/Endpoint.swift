//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
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

extension URLRequest {

    init(endpoint: Endpoint) throws {
        self.init(url: endpoint.url)
        self.setHeaders(from: endpoint)
        self.httpMethod = endpoint.method.rawValue
        self.httpBody = try Data(withJSONObject: endpoint.parameters)
        self.authorize(withToken: endpoint.authorizationToken)
    }

    fileprivate mutating func setHeaders(from endpoint: Endpoint) {
        var headers: [String: String] = [:]

        setContentType(for: endpoint, headers: &headers)
        setUserAgent(headers: &headers)

        headers.forEach { header, value in
            self.setValue(value, forHTTPHeaderField: header)
        }

        endpoint.headers?.forEach { header, value in
            self.setValue(String(describing: value), forHTTPHeaderField: header)
        }
    }

    fileprivate func setContentType(for endpoint: Endpoint, headers: inout [String: String]) {
        let acceptedContentTypes = [endpoint.acceptedContentType, "application/x.problem+json"].flatMap { $0 }
        headers["Accept"] = acceptedContentTypes.joined(separator: ",")
        headers["Content-Type"] = endpoint.contentType
    }

    fileprivate func setUserAgent(headers: inout [String: String]) {
        let sdkVersion = Bundle(for: RFC3339DateFormatter.self).version
        let appVersion = Bundle.main.version

        headers["User-Agent"] = [appVersion, sdkVersion, SystemInfo.platform].joined(separator: ", ")
    }

}
