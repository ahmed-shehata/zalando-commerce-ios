//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum HTTPMethod: String {

    case GET, POST, PUT, DELETE, PATCH

}

public enum HTTPStatus: Int {

    case unknown = -1
    case `continue` = 100
    case switchingProtocols = 101
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case unavailableForLegalReasons = 451
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505

    public init(statusCode: Int) {
        self = HTTPStatus(rawValue: statusCode) ?? .unknown
    }

    public init(response: HTTPURLResponse) {
        self.init(statusCode: response.statusCode)
    }

    public var isSuccessful: Bool {
        return (HTTPStatus.ok.rawValue..<HTTPStatus.badRequest.rawValue).contains(rawValue)
    }
}

func == (lhs: Int, rhs: HTTPStatus) -> Bool {
    return lhs == rhs.rawValue
}

func == (lhs: Int?, rhs: HTTPStatus) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs.rawValue
}
