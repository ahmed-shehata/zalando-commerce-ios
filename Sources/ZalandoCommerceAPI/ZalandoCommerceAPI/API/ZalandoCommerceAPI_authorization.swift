//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension ZalandoCommerceAPI {

    /// Determines if a client has an access token to call restricted endpoints.
    /// Having token doesn't guarantee it's unexpired or invalidated.
    public var isAuthorized: Bool {
        return config.authorizationToken != nil
    }

    /**
     Authorizes a client with given access token required in restricted endpoints.

     - Note: Stores `token` securely and makes it globally available for all calls
     to restricted endpoints identified by same `Options.environment`

     - Postcondition:
       - If a client is authorized successfully `NSNotification.Name.ZalandoCommerceAPIAuthorized`
         `NSNotification.Name.ZalandoCommerceAPIAuthorizationChanged` are posted on `NotificationCenter.default`
       - Both notifications contain `ZalandoCommerceAPI` instance as sending `object`,
            and `userInfo` containing `ZALANDO_COMMERCE_CLIENT_ID` equal to `Options.clientId`,
            and `ZALANDO_COMMERCE_USE_SANDBOX` equal to `Options.useSandboxEnvironment`.

     - Parameter token: access token passed to all restricted endpoint calls

     - Returns: `true` if token was correctly stored and client is authorized, otherwise `false`
     */
    @discardableResult
    public func authorize(with token: AuthorizationToken) -> Bool {
        var authorized = false
        if let token = APIAccessToken.store(token: token, for: config) {
            authorized = true
            notify(isAuthorized: authorized, withToken: token)
        }
        return authorized
    }

    /**
    Deauthorizes a client from accessing restricted endpoints.

    - Postcondition:
         - If a client is deauthorized successfully `NSNotification.Name.ZalandoCommerceAPIDeauthorized`
          and `NSNotification.Name.ZalandoCommerceAPIAuthorizationChanged` are posted on `NotificationCenter.default`.
         - Both notifications contain `ZalandoCommerceAPI` instance as sending `object`,
             and `userInfo` containing `ZALANDO_COMMERCE_CLIENT_ID` equal to `Options.clientId`,
             and `ZALANDO_COMMERCE_USE_SANDBOX` equal to `Options.useSandboxEnvironment`.
     */
    public func deauthorize() {
        guard let token = APIAccessToken.delete(for: config) else { return }
        notify(isAuthorized: false, withToken: token)
    }

    /**
     Deauthorizes all clients by removing all stored tokens and notifying about it
     - SeeAlso: `ZalandoCommerceAPI.deauthorize(with:)`
     */
    public static func deauthorizeAll() {
        APIAccessToken.wipe().forEach { token in
            notify(api: nil, isAuthorized: false, withToken: token)
        }
    }

}
