//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol AtlasErrorType: ErrorType {

    var localizedDescriptionKey: String { get }

}

public extension AtlasErrorType {

    var localizedDescriptionKey: String { return "AtlasError.\(self)" }

}

// TODO: rename all cases to camel case

public enum AtlasConfigurationError: AtlasErrorType {

    case IncorrectConfigServiceResponse
    case MissingClientId
    case MissingSalesChannel
    case MissingInterfaceLanguage

}

public enum AtlasAPIError: AtlasErrorType {

    case NoData
    case InvalidResponseFormat
    case NSURLError(code: Int, details: String?)
    case HTTP(status: HTTPStatus, details: String?)
    case Backend(status: Int?, title: String?, details: String?)
    case Unauthorized
    case Unknown(details: String?)

}

public enum LoginError: AtlasErrorType {

    case Unknown
    case MissingURL
    case AccessDenied
    case RequestFailed
    case NoAccessToken
    case MissingViewControllerToShowLoginForm

}
