//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

protocol Endpoint: CustomStringConvertible {

    var method: HTTPMethod { get }

    var contentType: String { get }
    var acceptedContentType: String { get }

    var URL: NSURL { get }

    var queryItems: [NSURLQueryItem]? { get }
    var parameters: [String: AnyObject]? { get }

}

extension Endpoint {

    var method: HTTPMethod { return .GET }

    var contentType: String { return "application/json" }
    var acceptedContentType: String { return "application/json" }

    var queryItems: [NSURLQueryItem]? { return nil }
    var parameters: [String: AnyObject]? { return nil }

}

extension Endpoint {

    var description: String {
        let params: String = {
            guard let parameters = parameters else { return nil }
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: [.PrettyPrinted])
                return String(data: data, encoding: NSUTF8StringEncoding)
            } catch let error {
                AtlasLogger.logError(error)
                return nil
            }
        }() ?? "<NO PARAMETERS>"

        return "\(method) \(URL)\n"
            + "Content-Type: \(contentType)\n"
            + "Accepted: \(acceptedContentType)\n\n"
            + params
            + "\n"
    }

}
