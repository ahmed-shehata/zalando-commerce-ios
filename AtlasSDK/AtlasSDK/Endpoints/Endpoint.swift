//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

protocol Endpoint: CustomStringConvertible {

    var method: HTTPMethod { get }

    var contentType: String { get }
    var acceptedContentType: String { get }

    var url: Foundation.URL { get }

    var queryItems: [URLQueryItem]? { get }
    var parameters: [String: Any]? { get }
    var headers: [String: Any]? { get }

    var requiresAuthorization: Bool { get }
}

extension Endpoint {

    var method: HTTPMethod { return .GET }

    var contentType: String { return "application/json" }
    var acceptedContentType: String { return "application/json" }

    var queryItems: [URLQueryItem]? { return nil }
    var parameters: [String: Any]? { return nil }
    var headers: [String: Any]? { return nil }

    var requiresAuthorization: Bool { return true }
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
