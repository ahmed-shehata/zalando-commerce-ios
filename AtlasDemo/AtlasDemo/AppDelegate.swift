//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

import AtlasSDK
import AtlasUI
import AtlasMockAPI

// TODO: might be temporary, but might be not. we'll see
var AtlasCheckoutInstance: AtlasCheckout? // swiftlint:disable:this variable_name

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var atlasCheckout: AtlasCheckout?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()

        let opts: Options
        if NSProcessInfo.hasMockedAPIEnabled {
            opts = Options(clientId: "atlas_Y2M1MzA",
                salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                useSandbox: true, interfaceLanguage: "en_DE",
                configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"))
        } else {
            opts = Options(clientId: "atlas_Y2M1MzA",
                salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                useSandbox: true, interfaceLanguage: "en_DE")

        }

        AtlasCheckout.configure(opts) { result in
            if case let .success(checkout) = result {
                AtlasCheckoutInstance = checkout
            }
        }

        return true
    }

}
