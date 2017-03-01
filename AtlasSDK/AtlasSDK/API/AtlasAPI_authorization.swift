//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension AtlasAPI {

    /// Determines if a client is authorized with access token to call restricted endpoints.
    public var isAuthorized: Bool {
        return config.authorizationToken != nil
    }

    /**
     Authorizes a client with given access token required in restricted endpoints.

     - Note: Stores `token` securely and makes it globally available for all calls
     to restricted endpoints identified by same `Options.environment`

     - Postcondition:
     - If a client is authorized successfully `NSNotification.Name.AtlasAuthorized`
     is posted on `NotificationCenter.default`, otherwise it is `NSNotification.Name.AtlasDeauthorized`.
     - `NSNotification.Name.AtlasAuthorizationChanged` is always posted regadless the result.

     - Parameter with: access token passed to all restricted endpoint calls

     - Returns: `true` if token was correctly stored and client is authorized, otherwise `false`
     */
    @discardableResult
    public func authorize(with token: AuthorizationToken) -> Bool {
        let token = APIAccessToken.store(token: token, for: config)
        let isAuthorized = token != nil
        notify(isAuthorized: isAuthorized, withToken: token)
        return isAuthorized
    }

    /// Deauthorizes a client from accessing restricted endpoints.
    public func deauthorize() {
        let token = APIAccessToken.delete(for: config)
        notify(isAuthorized: false, withToken: token)
    }

    /// Deauthorizes all clients by removing all stored tokens.
    public static func deauthorizeAll() {
        APIAccessToken.wipe().forEach { token in
            notify(api: nil, isAuthorized: false, withToken: token)
        }
    }

}
