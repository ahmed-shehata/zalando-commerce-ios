//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum PresentationMode {

    case banner
    case fullScreen

}

protocol UserPresentableError: AtlasError {

    func customMessage() -> String?
    func shouldDisplayGeneralMessage() -> Bool
    func presentationMode() -> PresentationMode

}

extension UserPresentableError {

    func customMessage() -> String? { return nil }

    func shouldDisplayGeneralMessage() -> Bool { return true }

    func presentationMode() -> PresentationMode { return .banner }

    var displayedTitle: String {
        return shouldDisplayGeneralMessage() ? Localizer.format(string: "AtlasCheckoutError.title") : title()
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.format(string: "AtlasCheckoutError.message.unclassified") : message()
    }

    fileprivate func title() -> String {
        let errorTitle = Localizer.format(string: localizedTitleKey)
        let errorCategoryTitle = Localizer.format(string: "\(type(of: self)).title")
        return errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle
    }

    fileprivate func message() -> String {
        return customMessage() ?? Localizer.format(string: localizedMessageKey)
    }

}

extension AtlasAPIError: UserPresentableError {

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

extension AtlasCheckoutError: UserPresentableError {

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

    func presentationMode() -> PresentationMode {
        switch self {
        case .outOfStock: return .fullScreen
        default: return .banner
        }
    }

    func customMessage() -> String? {
        switch self {
        case .priceChanged(let newPrice):
            let price = Localizer.format(price: newPrice)
            return Localizer.format(string: "AtlasCheckoutError.message.priceChanged", price)
        default: return nil
        }
    }

}

extension AtlasLoginError: UserPresentableError { }

extension AtlasConfigurationError: UserPresentableError { }
