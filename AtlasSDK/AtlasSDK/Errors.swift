//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol AtlasErrorType: ErrorType {

    var localizedDescriptionKey: String { get }

}

public extension AtlasErrorType {

    var localizedDescriptionKey: String { return "\(self.dynamicType).message.\(self)" }

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
    case unauthorized

    case nsURLError(code: Int, details: String?)
    case http(status: HTTPStatus, details: String?)
    case backend(status: Int?, title: String?, details: String?)

    case checkoutFailed(addresses: [UserAddress]?, cartId: String?, error: ErrorType)

}

public enum LoginError: AtlasErrorType {

    case missingURL
    case accessDenied
    case missingViewControllerToShowLoginForm

    case requestFailed(error: NSError?)

}

public func == (lhs: AtlasAPIError, rhs: AtlasAPIError) -> Bool {
    return lhs._code == rhs._code
}
