//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI
import AtlasMockAPI

typealias AppSetupCompletion = (configured: Bool) -> Void

class AppSetup {

    enum InterfaceLanguage: String {
        case English = "en"
        case Deutsch = "de"
    }

    private(set) static var atlasClient: AtlasAPIClient?
    private(set) static var options: Options?

    private static let defaultUseSandbox = true
    private static let defaultInterfaceLanguage = InterfaceLanguage.English

    static var isConfigured: Bool {
        return atlasClient != nil && options != nil
    }

    static func configure(completion: AppSetupCompletion) {
        prepareMockAPI()
        prepareApp()

        setAppOptions(prepareOptions(), completion: completion)
    }

    static func change(environmentToSandbox useSandbox: Bool) {
        Atlas.deauthorizeToken()
        setAppOptions(prepareOptions(useSandbox: useSandbox))
    }

    static func change(interfaceLanguage language: InterfaceLanguage) {
        setAppOptions(prepareOptions(interfaceLanguage: language))
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
            Atlas.deauthorizeToken()
        }
    }

    private static func setAppOptions(opts: Options, completion: AppSetupCompletion? = nil) {
        AtlasUI.configure(opts) { result in
            switch result {
            case .success(let client):
                AppSetup.atlasClient = client
                AppSetup.options = opts
                completion?(configured: true)
            case .failure:
                completion?(configured: false)
            }
        }
    }

    private static func prepareOptions(useSandbox useSandbox: Bool? = nil, interfaceLanguage: InterfaceLanguage? = nil) -> Options {
        let configurationURL: NSURL? = AtlasMockAPI.hasMockedAPIStarted ? AtlasMockAPI.endpointURL(forPath: "/config") : nil
        let sandbox = useSandbox ?? options?.useSandboxEnvironment ?? defaultUseSandbox
        let language = interfaceLanguage?.rawValue ?? options?.interfaceLanguage ?? defaultInterfaceLanguage.rawValue

        return Options(clientId: "atlas_Y2M1MzA",
                       salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                       useSandbox: sandbox,
                       interfaceLanguage: language,
                       configurationURL: configurationURL)
    }

}
