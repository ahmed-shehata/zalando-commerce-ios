//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI
import AtlasMockAPI

class AppSetup {

    private(set) static var checkout: AtlasCheckout?

    static func configure() {
        prepareMockAPI()
        prepareApp()

        let opts = prepareOptions(useSandbox: true)
        setAppOptions(opts)
    }

    static func switchEnvironment(useSandbox useSandbox: Bool, completion: (() -> Void)? = nil) {
        setAppOptions(prepareOptions(useSandbox: useSandbox), completion: completion)
    }

    private static var alwaysUseMockAPI: Bool {
        return NSProcessInfo.processInfo().arguments.contains("USE_MOCK_API")
    }

    private static func prepareMockAPI() {
        if alwaysUseMockAPI && !AtlasMockAPI.hasMockedAPIStarted {
            try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
        }
    }

    private static func prepareApp() {
        if AtlasMockAPI.hasMockedAPIStarted {
            Atlas.logoutUser()
        }
    }

    private static func setAppOptions(opts: Options, completion: (() -> Void)? = nil) {
        AtlasCheckout.configure(opts) { result in
            if case let .success(checkout) = result {
                AppSetup.checkout = checkout
                completion?()
            }
        }
    }

    private static func prepareOptions(useSandbox useSandbox: Bool) -> Options {
        let configurationURL: NSURL? = AtlasMockAPI.hasMockedAPIStarted ? AtlasMockAPI.endpointURL(forPath: "/config") : nil
        return Options(clientId: "atlas_Y2M1MzA",
            salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
            useSandbox: useSandbox,
            interfaceLanguage: "en",
            configurationURL: configurationURL)
    }

}
