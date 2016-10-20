//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Nimble
import AtlasMockAPI

@testable import AtlasSDK

class AtlasSpec: QuickSpec {

    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer() // swiftlint:disable:this force_try
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer() // swiftlint:disable:this force_try
    }

    override func spec() {

        describe("Atlas") {

            it("should save user token successfully") {
                self.loginUser()

                expect(Atlas.isUserLoggedIn()).to(beTrue())
            }

            it("should logout user successfully") {
                self.loginUser()
                Atlas.logoutUser()

                expect(Atlas.isUserLoggedIn()).to(beFalse())
            }

            it("should successfully return API client") {
                let opts = Options(clientId: "atlas_Y2M1MzA",
                    salesChannel: "82fe2e7f-8c4f-4aa1-9019-b6bde5594456",
                    useSandbox: true,
                    interfaceLanguage: "de",
                    configurationURL: AtlasMockAPI.endpointURL(forPath: "/config"),
                    authorizationHandler: MockAuthorizationHandler())

                waitUntil(timeout: 60) { done in
                    Atlas.configure(opts) { result in
                        switch result {
                        case .failure(let error):
                            fail(String(error))
                        case .success(let client):
                            expect(client).toNot(beNil())
                        }
                        done()
                    }
                }
            }
        }

    }

    private func loginUser() {
        APIAccessToken.store("TEST_TOKEN")
    }

}
