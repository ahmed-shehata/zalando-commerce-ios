//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import AtlasSDK
import AtlasMockAPI


struct TestOptions {

    static let clientId: String = "atlas_Y2M1MzA"
    static let useSandboxEnvironment: Bool = true
    static let salesChannel: String = "82fe2e7f-8c4f-4aa1-9019-b6bde5594456"
    static let interfaceLanguage: String = "en"

}

extension Options {

    static func forTests(clientId: String = TestOptions.clientId,
                         useSandboxEnvironment: Bool = TestOptions.useSandboxEnvironment,
                         salesChannel: String = TestOptions.salesChannel,
                         interfaceLanguage: String = TestOptions.interfaceLanguage) -> Options {
        return Options(clientId: clientId,
                       salesChannel: salesChannel,
                       useSandboxEnvironment: useSandboxEnvironment,
                       interfaceLanguage: interfaceLanguage,
                       configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
    }

}
