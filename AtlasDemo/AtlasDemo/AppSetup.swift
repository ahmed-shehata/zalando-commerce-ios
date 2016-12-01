//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI
import AtlasMockAPI

typealias AppSetupCompletion = (_ configured: Bool) -> Void

class AppSetup {

    enum InterfaceLanguage: String {
        case English = "en"
        case Deutsch = "de"
    }

    fileprivate(set) static var atlas: AtlasUI?
    fileprivate(set) static var options: Options?

    fileprivate static let defaultUseSandbox = true
    fileprivate static let defaultInterfaceLanguage = InterfaceLanguage.English

    static var isConfigured: Bool {
        return atlas != nil && options != nil
    }

    static func configure(completion: @escaping AppSetupCompletion) {
        prepareMockAPI()
        prepareApp()

        set(appOptions: prepareOptions(), completion: completion)
    }

    static func change(environmentToSandbox useSandbox: Bool) {
        Atlas.deauthorize()
        set(appOptions: prepareOptions(useSandbox: useSandbox))
    }

    static func change(interfaceLanguage language: InterfaceLanguage) {
        set(appOptions: prepareOptions(interfaceLanguage: language))
    }

    fileprivate static var alwaysUseMockAPI: Bool {
        return ProcessInfo.processInfo.arguments.contains("USE_MOCK_API")
    }

    fileprivate static func prepareMockAPI() {
        if alwaysUseMockAPI && !AtlasMockAPI.hasMockedAPIStarted {
            try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
        }
    }

    fileprivate static func prepareApp() {
        if AtlasMockAPI.hasMockedAPIStarted {
            Atlas.deauthorize()
        }
    }

    fileprivate static func set(appOptions options: Options, completion: AppSetupCompletion? = nil) {
        AtlasUI.configure(options: options) { result in
            switch result {
            case .success(let atlas):
                AppSetup.atlas = atlas
                AppSetup.options = options
                completion?(true)
            case .failure:
                completion?(false)
            }
        }
    }

    fileprivate static func prepareOptions(useSandbox: Bool? = nil, interfaceLanguage: InterfaceLanguage? = nil) -> Options {
        let configurationURL: URL? = AtlasMockAPI.hasMockedAPIStarted ? AtlasMockAPI.endpointURL(forPath: "/config") : nil
        let sandbox = useSandbox ?? options?.useSandboxEnvironment ?? defaultUseSandbox
        let language = interfaceLanguage?.rawValue ?? options?.interfaceLanguage ?? defaultInterfaceLanguage.rawValue

        return Options(clientId: "atlas_Y2M1MzA",
                       salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                       useSandbox: sandbox,
                       interfaceLanguage: language,
                       configurationURL: configurationURL)
    }

}
