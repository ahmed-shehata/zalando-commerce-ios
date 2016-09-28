//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(localizedWith provider: Localizer, formatArguments: CVarArgType?...) -> String

    func message(localizedWith provider: Localizer, formatArguments: CVarArgType?...) -> String

}

extension UserPresentable {

    func title(localizedWith localizer: Localizer, formatArguments: CVarArgType?...) -> String {
        return localizer.string("\(self.dynamicType).title", formatArguments: formatArguments)
    }

    func message(localizedWith localizer: Localizer, formatArguments: CVarArgType?...) -> String {
        return localizer.string(self.localizedDescriptionKey, formatArguments: formatArguments)
    }

}

extension AtlasAPIError: UserPresentable {

    func message(localizedWith localizer: Localizer, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .invalidResponseFormat, .noData, .unauthorized:
            return localizer.string(self.localizedDescriptionKey)
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
                return localizer.string("AtlasAPIError.message.checkoutFailed")
            }
        }
    }

}

extension LoginError: UserPresentable {

    func message(localizedWith localizer: Localizer, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .missingURL, .accessDenied, .missingViewControllerToShowLoginForm:
            return localizer.string(self.localizedDescriptionKey)
        case let .requestFailed(error):
            return "\(error?.localizedDescription~?)"
        }
    }

}

extension AtlasConfigurationError: UserPresentable { }
