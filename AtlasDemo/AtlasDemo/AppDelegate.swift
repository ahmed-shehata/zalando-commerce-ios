//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

import AtlasSDK
import AtlasUI
import AtlasMockAPI

var AtlasCheckoutInstance: AtlasCheckout? // swiftlint:disable:this variable_name

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()

        prepareMockAPI()
        prepareApp()

        let opts = prepareOptions()
        setAppOptions(opts)
        return true
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

    func setAppOptions(opts: Options, completion: (() -> Void)? = nil) {
        AtlasCheckout.configure(opts) { result in
            if case let .success(checkout) = result {
                AtlasCheckoutInstance = checkout
                if let completion = completion {
                    completion()
                }
            }
        }
    }

    private func prepareOptions() -> Options {
        var opts = Options(clientId: "atlas_Y2M1MzA",
            salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
            useSandbox: true, interfaceLanguage: "en_DE")

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

}
