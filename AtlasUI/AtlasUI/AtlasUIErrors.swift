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

    func titleArguments() -> [CVarArgType?]
    func messageArguments() -> [CVarArgType?]

    func customMessage() -> String?

    func shouldDisplayGeneralMessage() -> Bool
    func errorPresentationType() -> ErrorPresentationType

}

extension UserPresentable {

    func titleArguments() -> [CVarArgType?] {
        return []
    }

    func messageArguments() -> [CVarArgType?] {
        return []
    }

    func customMessage() -> String? {
        return nil
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return true
    }

    func errorPresentationType() -> ErrorPresentationType {
        return .banner
    }

    var displayedTitle: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.title") : title(titleArguments())
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.message") : message(messageArguments())
    }

    private func title(formatArguments: [CVarArgType?]) -> String {
        let errorTitle = Localizer.string(localizedTitleKey, formatArguments)
        let errorCategoryTitle = Localizer.string("\(self.dynamicType).title", formatArguments)
        return errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle
    }

    private func message(formatArguments: [CVarArgType?]) -> String {
        return customMessage() ?? Localizer.string(localizedMessageKey, formatArguments)
    }

}

extension AtlasAPIError: UserPresentable {

    func shouldDisplayGeneralMessage() -> Bool {
        switch self {
        case let .nsURLError(_, details): return details == nil
        default: return true
        }
    }

    func customMessage() -> String? {
        switch self {
        case let .nsURLError(_, details):
            return "\(details~?)"
        case let .http(status, details):
            return "\(details~?) (#\(status~?))"
        case let .backend(status, _, _, details):
            return "\(details~?) (#\(status~?))"
        case let .checkoutFailed(_, _, error):
            if case let AtlasAPIError.backend(_, _, _, details) = error {
                return "\(details~?)"
            } else {
                return nil
            }
        default: return nil
        }
    }

}

extension LoginError: UserPresentable {

    func customMessage() -> String? {
        switch self {
        case let .requestFailed(error): return "\(error?.localizedDescription~?)"
        default: return nil
        }
    }

}

extension AtlasConfigurationError: UserPresentable { }

extension AtlasCatalogError: UserPresentable {

    public func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

    public func errorPresentationType() -> ErrorPresentationType {
        switch self {
        case .outOfStock: return .fullScreen
        case .missingAddress, .priceChanged: return .banner
        }
    }

    func arguments() -> [CVarArgType?] {
        switch self {
        case .priceChanged(let newPrice): return [Localizer.price(newPrice)]
        default: return []
        }
    }

}
