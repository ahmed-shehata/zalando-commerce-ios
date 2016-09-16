//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI
import AtlasMockAPI

class AppSetup {
    var checkout: AtlasCheckout? // swiftlint:disable:this variable_name

    func setupApp() {
        prepareMockAPI()
        prepareApp()

        let opts = prepareOptions(useSandbox: true)
        setAppOptions(opts)
    }

    private var alwaysUseMockAPI: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    private func prepareApp() {
        if AtlasMockAPI.hasMockedAPIStarted {
            Atlas.logoutCustomer()
        }
    }

    private func setAppOptions(opts: Options, completion: (() -> Void)? = nil) {
        AtlasCheckout.configure(opts) { result in
            if case let .success(checkout) = result {
                self.checkout = checkout
                if let completion = completion {
                    completion()
                }
            }
        }
    }

    private func prepareOptions(useSandbox useSandbox: Bool) -> Options {
        var opts = Options(clientId: "atlas_Y2M1MzA",
            salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
            useSandbox: useSandbox, interfaceLanguage: "en_DE")

        if AtlasMockAPI.hasMockedAPIStarted {
            opts = Options(basedOn: opts, configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
        }

        return opts
    }

    private func prepareMockAPI() {
        if alwaysUseMockAPI && !AtlasMockAPI.hasMockedAPIStarted {
            try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
        }
    }

    func switchEnvironment(useSandbox useSandbox: Bool, completion: (() -> Void)? = nil) {
        setAppOptions(prepareOptions(useSandbox: useSandbox), completion: completion)
    }

}
