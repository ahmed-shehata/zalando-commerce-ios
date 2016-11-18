//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol AtlasErrorType: Error {

    var localizedTitleKey: String { get }
    var localizedMessageKey: String { get }

}

public extension AtlasErrorType {

    var localizedTitleKey: String { return "\(type(of: self)).title.\(self)" }
    var localizedMessageKey: String { return "\(type(of: self)).message.\(self)" }

}

public enum AtlasConfigurationError: AtlasErrorType {

    case incorrectConfigServiceResponse
    case missingClientId
    case missingSalesChannel

}

public enum AtlasAPIError: AtlasErrorType {

    case noData
    case noInternet
    case invalidResponseFormat
    case unauthorized

    case nsURLError(code: Int, details: String?)
    case http(status: HTTPStatus, details: String?)
    case backend(status: Int?, type: String?, title: String?, details: String?)

    case checkoutFailed(cart: Cart?, error: Error)

}

public enum AtlasCheckoutError: AtlasErrorType {

    case unclassified
    case outOfStock
    case missingAddress
    case missingAddressAndPayment
    case priceChanged(newPrice: MoneyAmount)
    case paymentMethodNotAvailable
    case checkoutFailure
    case addressInvalid

}
