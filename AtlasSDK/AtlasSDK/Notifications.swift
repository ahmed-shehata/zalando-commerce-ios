//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

extension NSNotification.Name {

    public static let AtlasAuthorized = NSNotification.Name(rawValue: "Atlas.NotificationAuthorized")
    public static let AtlasDeauthorized = NSNotification.Name(rawValue: "Atlas.NotificationDeauthorized")
    public static let AtlasAuthorizationChanged = NSNotification.Name(rawValue: "Atlas.NotificationAuthorizationChanged")

}

extension AtlasAPI {

    func notify(isAuthorized: Bool, withToken token: APIAccessToken?) {
        AtlasAPI.notify(api: self, isAuthorized: isAuthorized, withToken: token)
    }

    static func notify(api: AtlasAPI?, isAuthorized: Bool, withToken token: APIAccessToken?) {
        let userInfo = token?.notificationUserInfo
        let authNotification: NSNotification.Name = isAuthorized ? .AtlasAuthorized : .AtlasDeauthorized

        NotificationCenter.default.post(name: authNotification, object: api, userInfo: userInfo)
        NotificationCenter.default.post(name: .AtlasAuthorizationChanged, object: api, userInfo: userInfo)
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
