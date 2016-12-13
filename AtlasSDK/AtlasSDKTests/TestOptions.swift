//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import AtlasSDK
import AtlasMockAPI

extension Options {

    static func forTests(clientId: String = "atlas_Y2M1MzA",
                         useSandboxEnvironment: Bool = true,
                         salesChannel: String = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                         interfaceLanguage: String = "en") -> Options {
        return Options(clientId: clientId,
                       salesChannel: salesChannel,
                       useSandboxEnvironment: useSandboxEnvironment,
                       interfaceLanguage: interfaceLanguage,
                       configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
    }

}
