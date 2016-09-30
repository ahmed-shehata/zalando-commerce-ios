//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI
import AtlasMockAPI

class AppSetup {

    private(set) static var checkout: AtlasCheckout?
    private static var options: Options?

    private static let defaultUseSandbox = false
    private static let defaultInterfaceLanguage = "en"

    static var interfaceLanguage: String? {
        return checkout?.client.config.interfaceLocale.objectForKey(NSLocaleLanguageCode) as? String
    }

    static func configure() {
        prepareMockAPI()
        prepareApp()

        setAppOptions(prepareOptions())
    }

    static func change(environmentToSandbox useSandbox: Bool, completion: (() -> Void)? = nil) {
        setAppOptions(prepareOptions(useSandbox: useSandbox), completion: completion)
    }

    static func change(interfaceLanguage language: String, completion: (() -> Void)? = nil) {
        setAppOptions(prepareOptions(interfaceLanguage: language), completion: completion)
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
                AppSetup.options = opts
                AppSetup.checkout = checkout
                completion?()
            }
        }
    }

    private static func prepareOptions(useSandbox useSandbox: Bool? = nil, interfaceLanguage: String? = nil) -> Options {
        let configurationURL: NSURL? = AtlasMockAPI.hasMockedAPIStarted ? AtlasMockAPI.endpointURL(forPath: "/config") : nil
        let sandbox = useSandbox ?? options?.useSandboxEnvironment ?? defaultUseSandbox
        let language = interfaceLanguage ?? options?.interfaceLanguage ?? defaultInterfaceLanguage

        return Options(clientId: "atlas_Y2M1MzA",
            salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
            useSandbox: sandbox,
            interfaceLanguage: language,
            configurationURL: configurationURL)
    }

}
