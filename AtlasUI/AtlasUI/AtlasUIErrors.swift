//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

    func shouldDisplayGeneralMessage() -> Bool

    func shouldCancelCheckout() -> Bool

}

extension UserPresentable {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString("\(self.dynamicType).title", formatArguments: formatArguments)
    }

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString(self.localizedDescriptionKey, formatArguments: formatArguments)
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return true
    }

    func shouldCancelCheckout() -> Bool {
        return false
    }

}

extension AtlasAPIError: UserPresentable {

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .invalidResponseFormat, .noData, .unauthorized:
            return provider.localizer.localizedString(self.localizedDescriptionKey)
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
                return provider.localizer.localizedString("AtlasAPIError.message.checkoutFailed")
            }
        }
    }

}

extension LoginError: UserPresentable {

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .missingURL, .accessDenied, .missingViewControllerToShowLoginForm:
            return provider.localizer.localizedString(self.localizedDescriptionKey)
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
