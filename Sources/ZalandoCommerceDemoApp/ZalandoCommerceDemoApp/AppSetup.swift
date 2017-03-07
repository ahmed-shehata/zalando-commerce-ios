//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import struct ZalandoCommerceAPI.Options
import struct ZalandoCommerceAPI.ZalandoCommerceAPI
import ZalandoCommerceUI
import MockAPI

typealias AppSetupCompletion = (_ configured: Bool) -> Void

class AppSetup {

    fileprivate(set) static var atlas: ZalandoCommerceUI?
    fileprivate(set) static var options: Options?

    struct Defaults {
        fileprivate static let useSandbox = true
        fileprivate static let interfaceLanguage: InterfaceLanguage = .english
        fileprivate static let salesChannel: SalesChannel = .germany
    }

    static var isConfigured: Bool {
        return atlas != nil && options != nil
    }

    static func configure(completion: @escaping AppSetupCompletion) {
        prepareForTests()
        prepareMockAPI()

        set(appOptions: prepareOptions(), completion: completion)
    }

    static func isAuthorized() -> Bool {
        return atlas?.api.isAuthorized ?? false
    }

    static func deauthorize() {
        atlas?.api.deauthorize()
    }

    static func change(environmentToSandbox useSandbox: Bool) {
        set(appOptions: prepareOptions(useSandbox: useSandbox))
    }

    static func change(interfaceLanguage: InterfaceLanguage) {
        set(appOptions: prepareOptions(interfaceLanguage: interfaceLanguage))
    }

    static func change(salesChannel: SalesChannel) {
        set(appOptions: prepareOptions(salesChannel: salesChannel))
    }

}

extension AppSetup {

    private static var isInTestsEnvironment: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        || ProcessInfo.processInfo.arguments.contains("UI_TESTS")
    }

    private static var alwaysUseMockAPI: Bool {
        return ProcessInfo.processInfo.arguments.contains("USE_MOCK_API")
    }

    fileprivate static func prepareMockAPI() {
        if alwaysUseMockAPI && !MockAPI.hasMockedAPIStarted {
            try! MockAPI.startServer() // swiftlint:disable:this force_try
        }
    }

    fileprivate static func prepareForTests() {
        if isInTestsEnvironment {
            ZalandoCommerceAPI.deauthorizeAll()
        }
    }

    fileprivate static func set(appOptions options: Options, completion: AppSetupCompletion? = nil) {
        ZalandoCommerceUI.configure(options: options) { result in
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

    fileprivate static func prepareOptions(useSandbox: Bool? = nil,
                                           interfaceLanguage: InterfaceLanguage? = nil,
                                           salesChannel: SalesChannel? = nil) -> Options {
        let configurationURL: URL? = MockAPI.hasMockedAPIStarted ? MockAPI.endpointURL(forPath: "/config") : nil
        let sandbox = useSandbox ?? options?.useSandboxEnvironment ?? Defaults.useSandbox
        let language = interfaceLanguage?.rawValue ?? options?.interfaceLanguage ?? Defaults.interfaceLanguage.rawValue
        let salesChannel = salesChannel?.rawValue ?? options?.salesChannel ?? Defaults.salesChannel.rawValue

        return Options(clientId: "atlas_Y2M1MzA",
                       salesChannel: salesChannel,
                       useSandboxEnvironment: sandbox,
                       interfaceLanguage: language,
                       configurationURL: configurationURL)
    }

}
