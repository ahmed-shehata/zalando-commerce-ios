//
// Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble
import AtlasCommons
import AtlasMockAPI

@testable import AtlasSDK

class PublicAtlasSDKSpec: QuickSpec {

    private var atlas: AtlasSDK!

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func spec() {

        beforeEach {
            let opts = Options(clientId: "clientId", salesChannel: "SALES_CHANNEL_ID", useSandbox: true)
            let configURL = AtlasMockAPI.endpointURL(forPath: "/config")
            self.atlas = AtlasSDK()
            self.atlas.register { ConfigClient(options: opts, endpointURL: configURL) as Configurator }
            self.atlas.setup(opts)
        }

        describe("PublicAtlasSDKSpec") {

            it("should save user token successfully") {

                APIAccessToken.store("TEST_TOKEN")

                expect(APIAccessToken.retrieve()).to(equal("TEST_TOKEN"))
            }

            it("should logout user successfully") {

                APIAccessToken.store("TEST_TOKEN")

                AtlasSDK.logoutCustomer()

                expect(APIAccessToken.retrieve()).to(beNil())
            }

        }
    }

    private func expectStatusToEqualOK() {
        expect(self.atlas.status).toEventually(equal(AtlasSDK.Status.ConfigurationOK), timeout: 5)
    }

}
