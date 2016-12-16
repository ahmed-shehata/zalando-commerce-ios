//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import AtlasSDK
import AtlasMockAPI

extension Options {

    static func forTests(clientId: String = TestConsts.clientId,
                         useSandboxEnvironment: Bool = TestConsts.useSandboxEnvironment,
                         salesChannel: String = TestConsts.salesChannel,
                         interfaceLanguage: String = TestConsts.interfaceLanguage,
                         configurationURL: URL = TestConsts.configURL) -> Options {
        return Options(clientId: clientId,
                       salesChannel: salesChannel,
                       useSandboxEnvironment: useSandboxEnvironment,
                       interfaceLanguage: interfaceLanguage,
                       configurationURL: configurationURL)
    }

}
