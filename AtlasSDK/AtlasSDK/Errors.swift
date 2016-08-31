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

public enum AtlasConfigurationError: AtlasErrorType {

    case incorrectConfigServiceResponse
    case missingClientId
    case missingSalesChannel
    case missingInterfaceLanguage

}

public enum AtlasAPIError: AtlasErrorType {

    case noData
    case invalidResponseFormat
    case nsURLError(code: Int, details: String?)
    case http(status: HTTPStatus, details: String?)
    case backend(status: Int?, title: String?, details: String?)
    case unauthorized
    case emptyAddressList

}

public enum LoginError: AtlasErrorType {

    case missingURL
    case accessDenied
    case requestFailed
    case noAccessToken
    case missingViewControllerToShowLoginForm

}

public func == (lhs: AtlasAPIError, rhs: AtlasAPIError) -> Bool {
    return lhs._code == rhs._code
}
