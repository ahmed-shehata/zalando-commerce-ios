//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import AtlasSDK
import AtlasMockAPI

extension Options {

    static func forTests(interfaceLanguage: String = "en") -> Options {
        return Options(clientId: "CLIENT_ID",
                       salesChannel: "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
                       useSandbox: true,
                       interfaceLanguage: interfaceLanguage,
                       configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
    }

}
