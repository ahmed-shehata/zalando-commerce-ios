//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension NSNotification.Name {

    /**
     Posted on `ZalandoCommerceAPI` authorization.
     - SeeAlso: `ZalandoCommerceAPI.authorize(with:)`
     */
    public static let ZalandoCommerceAPIAuthorized =
        NSNotification.Name(rawValue: "ZalandoCommerceAPI.Notification.Authorized")

    /**
     Posted on `ZalandoCommerceAPI` deauthorization.
     - SeeAlso: `ZalandoCommerceAPI.deauthorize(with:)`
     */
    public static let ZalandoCommerceAPIDeauthorized =
        NSNotification.Name(rawValue: "ZalandoCommerceAPI.Notification.Deauthorized")

    /**
     Posted on `ZalandoCommerceAPI` authorization state change.
     - SeeAlso: `ZalandoCommerceAPI.authorize(with:)`
     */
    public static let ZalandoCommerceAPIAuthorizationChanged =
        NSNotification.Name(rawValue: "ZalandoCommerceAPI.Notification.AuthorizationChanged")

}

extension ZalandoCommerceAPI {

    func notify(isAuthorized: Bool, withToken token: APIAccessToken) {
        ZalandoCommerceAPI.notify(api: self, isAuthorized: isAuthorized, withToken: token)
    }

    static func notify(api: ZalandoCommerceAPI?, isAuthorized: Bool, withToken token: APIAccessToken) {
        let userInfo = token.notificationUserInfo
        let authNotification: NSNotification.Name = isAuthorized ? .ZalandoCommerceAPIAuthorized : .ZalandoCommerceAPIDeauthorized

        NotificationCenter.default.post(name: authNotification, object: api, userInfo: userInfo)
        NotificationCenter.default.post(name: .ZalandoCommerceAPIAuthorizationChanged, object: api, userInfo: userInfo)
    }

}

extension APIAccessToken {

    var notificationUserInfo: [AnyHashable: Any] {
        return [
            Options.InfoKey.useSandboxEnvironment: self.useSandboxEnvironment,
            Options.InfoKey.clientId: self.clientId
        ]
    }
}
