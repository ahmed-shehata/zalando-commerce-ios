//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

enum PresentationMode {

    case banner
    case fullScreen

}

protocol UserPresentableError: LocalizableError {

    var customMessage: String? { get }
    var shouldDisplayGeneralMessage: Bool { get }
    var presentationMode: PresentationMode { get }

}

extension UserPresentableError {

    var customMessage: String? {
        return nil
    }

    var shouldDisplayGeneralMessage: Bool {
        return true
    }

    var presentationMode: PresentationMode {
        return .banner
    }

    var displayedTitle: String {
        return shouldDisplayGeneralMessage ? Localizer.format(string: "CheckoutError.title") : title()
    }

    var displayedMessage: String {
        return shouldDisplayGeneralMessage ? Localizer.format(string: "CheckoutError.message.unclassified") : message()
    }

    fileprivate func title() -> String {
        let errorTitle = Localizer.format(string: localizedTitleKey)
        let errorCategoryTitle = Localizer.format(string: "\(type(of: self)).title")
        return errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle
    }

    fileprivate func message() -> String {
        return customMessage ?? Localizer.format(string: localizedMessageKey)
    }

}

extension APIError: UserPresentableError {

    var shouldDisplayGeneralMessage: Bool {
        switch self {
        case .noInternet: return false
        case let .nsURLError(_, details): return details == nil
        default: return true
        }
    }

    var customMessage: String? {
        switch self {
        case let .nsURLError(_, details): return details~?
        default: return nil
        }
    }

}

extension CheckoutError: UserPresentableError {

    var shouldDisplayGeneralMessage: Bool {
        return false
    }

    var presentationMode: PresentationMode {
        switch self {
        case .outOfStock: return .fullScreen
        default: return .banner
        }
    }

    var customMessage: String? {
        switch self {
        case .priceChanged(let newPrice):
            let price = Localizer.format(price: newPrice)
            return Localizer.format(string: "CheckoutError.message.priceChanged", price)
        default: return nil
        }
    }

}

extension LoginError: UserPresentableError { }

extension ConfigurationError: UserPresentableError { }
