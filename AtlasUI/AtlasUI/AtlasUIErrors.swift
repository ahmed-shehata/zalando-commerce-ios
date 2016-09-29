//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(formatArguments: CVarArgType?...) -> String

    func message(formatArguments: CVarArgType?...) -> String

    func shouldDisplayGeneralMessage() -> Bool

    func shouldCancelCheckout() -> Bool

}

extension UserPresentable {

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("\(self.dynamicType).title", formatArguments)
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string(self.localizedDescriptionKey, formatArguments)
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return true
    }

    func shouldCancelCheckout() -> Bool {
        return false
    }

}

extension AtlasAPIError: UserPresentable {

    func message(formatArguments: CVarArgType?...) -> String {
        switch self {
        case .invalidResponseFormat, .noData, .unauthorized:
            return Localizer.string(self.localizedDescriptionKey)
        case let .nsURLError(code, details):
            return "\(details) (#\(code))"
        case let .http(status, details):
            return "\(details~?) (#\(status~?))"
        case let .backend(status, _, _, details):
            return "\(details~?) (#\(status~?))"
        case let .checkoutFailed(_, _, error):
            if case let AtlasAPIError.backend(_, _, _, details) = error {
                return "\(details~?)"
            } else {
                return Localizer.string("AtlasAPIError.message.checkoutFailed")
            }
        }
    }

}

extension LoginError: UserPresentable {

    func message(formatArguments: CVarArgType?...) -> String {
        switch self {
        case .missingURL, .accessDenied, .missingViewControllerToShowLoginForm:
            return Localizer.string(self.localizedDescriptionKey)
        case let .requestFailed(error):
            return "\(error?.localizedDescription~?)"
        }
    }

}

extension AtlasConfigurationError: UserPresentable { }

extension AtlasCatalogError: UserPresentable {

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
