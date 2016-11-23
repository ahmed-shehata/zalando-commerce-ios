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
        return shouldDisplayGeneralMessage() ? Localizer.string("AtlasCheckoutError.title") : title()
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("AtlasCheckoutError.message.unclassified") : message()
    }

    fileprivate func title() -> String {
        let errorTitle = Localizer.string(localizedTitleKey)
        let errorCategoryTitle = Localizer.string("\(type(of: self)).title")
        return errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle
    }

    fileprivate func message() -> String {
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

extension AtlasCheckoutError: UserPresentable {

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

    func errorPresentationType() -> ErrorPresentationType {
        switch self {
        case .outOfStock: return .fullScreen
        default: return .banner
        }
    }

    func customMessage() -> String? {
        switch self {
        case .priceChanged(let newPrice): return Localizer.string("AtlasCheckoutError.message.priceChanged", Localizer.price(newPrice))
        default: return nil
        }
    }

}

extension AtlasLoginError: UserPresentable { }

extension AtlasConfigurationError: UserPresentable { }
