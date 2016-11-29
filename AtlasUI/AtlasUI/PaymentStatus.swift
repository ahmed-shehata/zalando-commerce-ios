//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

enum PaymentStatus: Equatable {

    case guestRedirect(encryptedCheckoutId: String, encryptedToken: String)
    case redirect
    case success
    case cancel
    case error

    static var statusKey = "payment_status"

    private init?(withStatus status: String) {
        switch status {
        case "success": self = .success
        case "cancel": self = .cancel
        case "error": self = .error
        default: return nil
        }
    }

    private init?(withPath path: [String]) {
        guard let firstComponent = path.first else { return nil }
        switch firstComponent {
        case "redirect":
            if path.count == 3 {
                self = .guestRedirect(encryptedCheckoutId: path[1], encryptedToken: path[2])
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    init?(callbackURLComponents: NSURLComponents, requestURLComponents: NSURLComponents) {
        guard let
            callbackHost = callbackURLComponents.host,
            requestHost = requestURLComponents.host
            where
            callbackHost.lowercaseString == requestHost.lowercaseString
            else { return nil }

        if let
            status = requestURLComponents.queryItems?.filter({ $0.name == PaymentStatus.statusKey }).first?.value,
            paymentStatus = PaymentStatus(withStatus: status) {
            self = paymentStatus
        } else if let
            path = requestURLComponents.path?.componentsSeparatedByString("/").filter({ !$0.isEmpty }),
            paymentStatus = PaymentStatus(withPath: path) {
            self = paymentStatus
        } else {
            self = .redirect
        }
    }

}

func == (lhs: PaymentStatus, rhs: PaymentStatus) -> Bool {
    switch (lhs, rhs) {
    case (.guestRedirect(let lhsCheckoutId, let lhsToken), .guestRedirect(let rhsCheckoutId, let rhsToken)):
        return lhsCheckoutId == rhsCheckoutId && lhsToken == rhsToken
    case (.redirect, .redirect): return true
    case (.success, .success): return true
    case (.cancel, .cancel): return true
    case (.error, .error): return true
    default: return false
    }
}
