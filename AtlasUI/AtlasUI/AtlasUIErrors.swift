//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(formatArguments: Any?...) -> String

    func message(formatArguments: Any?...) -> String

}

extension UserPresentable {

    func title(formatArguments: Any?...) -> String {
        return UILocalizer.string("\(self.dynamicType).title", formatArguments)
    }

    func message(formatArguments: Any?...) -> String {
        return UILocalizer.string(self.localizedDescriptionKey, formatArguments)
    }

}

extension AtlasAPIError: UserPresentable {

    func message(localizedWith localizer: Localizer, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .invalidResponseFormat, .noData, .unauthorized:
            return UILocalizer.string(self.localizedDescriptionKey)
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
                return UILocalizer.string("AtlasAPIError.message.checkoutFailed")
            }
        }
    }

}

extension LoginError: UserPresentable {

    func message(formatArguments: CVarArgType?...) -> String {
        switch self {
        case .missingURL, .accessDenied, .missingViewControllerToShowLoginForm:
            return UILocalizer.string(self.localizedDescriptionKey)
        case let .requestFailed(error):
            return "\(error?.localizedDescription~?)"
        }
    }

}

extension AtlasConfigurationError: UserPresentable { }
