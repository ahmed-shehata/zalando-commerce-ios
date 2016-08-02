//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

public enum HTTPStatus: Int {
    case OK = 200
    case MovedPermanently = 301
    case Found = 302
    case NotModified = 304
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
}

public func == (lhs: Int, rhs: HTTPStatus) -> Bool {
    return lhs == rhs.rawValue
}

public func == (lhs: Int?, rhs: HTTPStatus) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs.rawValue
}
