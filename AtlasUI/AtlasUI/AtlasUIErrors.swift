//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

public enum ErrorPresentationType {
    case banner
    case fullScreen
}

public protocol UserPresentable: AtlasErrorType {

    func customTitle() -> String?

    func customMessage() -> String?

    func shouldDisplayGeneralMessage() -> Bool

    func errorPresentationType() -> ErrorPresentationType

}

extension UserPresentable {

    public func customTitle() -> String? { return nil}

    public func customMessage() -> String? { return nil }

    public func shouldDisplayGeneralMessage() -> Bool { return true }

    public func errorPresentationType() -> ErrorPresentationType { return .banner }

    public var displayedTitle: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("AtlasCheckoutError.title") : title()
    }

    public var displayedMessage: String {
        return shouldDisplayGeneralMessage() ? Localizer.string("AtlasCheckoutError.message.unclassified") : message()
    }

    private func title() -> String {
        let errorTitle = Localizer.string(localizedTitleKey)
        let errorCategoryTitle = Localizer.string("\(self.dynamicType).title")
        return customTitle() ?? (errorTitle == localizedTitleKey ? errorCategoryTitle : errorTitle)
    }

    private func message() -> String {
        return customMessage() ?? Localizer.string(localizedMessageKey)
    }

}

extension AtlasAPIError: UserPresentable {

    public func shouldDisplayGeneralMessage() -> Bool {
        switch self {
        case .noInternet: return false
        case let .nsURLError(_, details): return details == nil
        default: return true
        }
    }

    public func customMessage() -> String? {
        switch self {
        case let .nsURLError(_, details): return details~?
        default: return nil
        }
    }

}

extension AtlasCheckoutError: UserPresentable {

    public func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

    public func errorPresentationType() -> ErrorPresentationType {
        switch self {
        case .outOfStock: return .fullScreen
        default: return .banner
        }
    }

    public func customMessage() -> String? {
        switch self {
        case .priceChanged(let newPrice): return Localizer.string("AtlasCheckoutError.message.priceChanged", Localizer.price(newPrice))
        default: return nil
        }
    }

}

extension LoginError: UserPresentable { }

extension AtlasConfigurationError: UserPresentable { }
