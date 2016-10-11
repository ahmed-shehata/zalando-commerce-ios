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

    func customMessage() -> String?

    func shouldDisplayGeneralMessage() -> Bool

    func errorPresentationType() -> ErrorPresentationType

}

extension UserPresentable {

    func customMessage() -> String? { return nil }

    func shouldDisplayGeneralMessage() -> Bool { return true }

    func errorPresentationType() -> ErrorPresentationType { return .banner }

    var displayedTitle: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.title") : title()
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("Error.unclassified.message") : message()
    }

    private func title() -> String {
        let errorTitle = Localizer.string(localizedTitleKey)
        let errorCategoryTitle = Localizer.string("\(self.dynamicType).title")
        return errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle
    }

    private func message() -> String {
        return customMessage() ?? Localizer.string(localizedMessageKey)
    }

}

extension AtlasAPIError: UserPresentable {

    func shouldDisplayGeneralMessage() -> Bool {
        switch self {
        case .noInternet: return false
        case let .nsURLError(_, details): return details == nil
        default: return true
        }
    }

    func customMessage() -> String? {
        switch self {
        case let .nsURLError(_, details): return details~?
        default: return nil
        }
    }

}

extension AtlasCatalogError: UserPresentable {

    public func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

    public func errorPresentationType() -> ErrorPresentationType {
        switch self {
        case .outOfStock: return .fullScreen
        case .paymentMethodNotAvailable, .missingAddress, .priceChanged: return .banner
        }
    }

    func customMessage() -> String? {
        switch self {
        case .priceChanged(let newPrice): return Localizer.string("AtlasCatalogError.message.priceChanged", Localizer.price(newPrice))
        default: return nil
        }
    }

}

extension LoginError: UserPresentable { }

extension AtlasConfigurationError: UserPresentable { }
