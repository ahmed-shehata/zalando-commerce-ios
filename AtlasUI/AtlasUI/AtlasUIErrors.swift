//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

}

extension UserPresentable {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString("\(self.dynamicType).title", formatArguments: formatArguments)
    }

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString(self.localizedDescriptionKey, formatArguments: formatArguments)
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
