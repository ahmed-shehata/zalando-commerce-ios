//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol AtlasErrorType: ErrorType {

    var localizedDescriptionKey: String { get }
    func shouldDisplayGeneralMessage() -> Bool
    func shouldCancelCheckout() -> Bool

}

public extension AtlasErrorType {

    var localizedDescriptionKey: String { return "\(self.dynamicType).message.\(self)" }
    func shouldDisplayGeneralMessage() -> Bool { return true }
    func shouldCancelCheckout() -> Bool { return false }

}

public enum AtlasConfigurationError: AtlasErrorType {

    case incorrectConfigServiceResponse
    case missingClientId
    case missingSalesChannel

}

public enum AtlasAPIError: AtlasErrorType {

    case noData
    case invalidResponseFormat
    case unauthorized

    case nsURLError(code: Int, details: String?)
    case http(status: HTTPStatus, details: String?)
    case backend(status: Int?, type: String?, title: String?, details: String?)

    case checkoutFailed(addresses: [UserAddress]?, cartId: String?, error: ErrorType)

}

public enum AtlasCatalogError: AtlasErrorType {

    case outOfStock

    public func shouldDisplayGeneralMessage() -> Bool {
        switch self {
        case .outOfStock: return false
        }
    }

    public func shouldCancelCheckout() -> Bool {
        switch self {
        case .outOfStock: return true
        }
    }

}
