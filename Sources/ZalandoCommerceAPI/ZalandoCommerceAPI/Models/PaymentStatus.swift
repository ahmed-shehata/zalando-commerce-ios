//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public enum PaymentStatus: Equatable {

    case guestRedirect(guestCheckoutId: GuestCheckoutId)
    case redirect
    case success
    case cancel
    case error

    static var statusKey = "payment_status"

    public init?(callbackURLComponents: URLComponents, requestURLComponents: URLComponents) {
        guard let callbackHost = callbackURLComponents.host,
            let requestHost = requestURLComponents.host,
            callbackHost.lowercased() == requestHost.lowercased()
            else { return nil }

        self.init(requestURLComponents: requestURLComponents)
    }

}

extension PaymentStatus {

    fileprivate init?(from string: String?) {
        guard let string = string else { return nil }

        switch string {
        case "success": self = .success
        case "cancel": self = .cancel
        case "error": self = .error
        default: return nil
        }
    }

    fileprivate init(requestURLComponents: URLComponents) {
        if let paymentStatus = PaymentStatus(from: requestURLComponents.paymentStatus) {
            self = paymentStatus
        } else if let guestRedirect = requestURLComponents.guestRedirect {
            let guestCheckoutId = GuestCheckoutId(checkoutId: guestRedirect.encryptedCheckoutId,
                                                  token: guestRedirect.encryptedToken)
            self = .guestRedirect(guestCheckoutId: guestCheckoutId)
        } else {
            self = .redirect
        }
    }

    public static func == (lhs: PaymentStatus, rhs: PaymentStatus) -> Bool {
        switch (lhs, rhs) {
        case (.guestRedirect(let lhsGuestCheckoutId), .guestRedirect(let rhsGuestCheckoutId)):
            return lhsGuestCheckoutId.checkoutId == lhsGuestCheckoutId.checkoutId
                && lhsGuestCheckoutId.token == rhsGuestCheckoutId.token
        case (.redirect, .redirect): return true
        case (.success, .success): return true
        case (.cancel, .cancel): return true
        case (.error, .error): return true
        default: return false
        }
    }

}

extension URLComponents {

    fileprivate var paymentStatus: String? {
        return queryItems?.first(where: { $0.name == PaymentStatus.statusKey })?.value
    }

    fileprivate var guestRedirect: (encryptedCheckoutId: String, encryptedToken: String)? {
        guard isGuestRedirect else { return nil }
        return (encryptedCheckoutId: pathComponents[1], encryptedToken: pathComponents[2])
    }

    private var isGuestRedirect: Bool {
        guard let action = pathComponents.first, action == "redirect" else { return false }
        return pathComponents.count == 3
    }

    private var pathComponents: [String] {
        return path.components(separatedBy: "/").filter({ !$0.isEmpty })
    }

}
