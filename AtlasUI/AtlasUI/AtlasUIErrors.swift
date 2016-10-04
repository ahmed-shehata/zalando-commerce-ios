//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public enum ErrorPresentationType {
    case banner
    case fullScreen
}

protocol UserPresentable: AtlasErrorType {

    func title(formatArguments: CVarArgType?...) -> String

    func message(formatArguments: CVarArgType?...) -> String

    func shouldDisplayGeneralMessage() -> Bool

    func errorPresentationType() -> ErrorPresentationType

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

    func errorPresentationType() -> ErrorPresentationType {
        return .banner
    }

    var displayedTitle: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.title") : title()
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.message") : message()
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

    public func errorPresentationType() -> ErrorPresentationType {
        switch self {
        case .outOfStock: return .fullScreen
        }
    }

}

struct ReachabilityUserPresentableError: UserPresentable {

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.title")
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.message")
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }
}
