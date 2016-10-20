//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Nimble

@testable import AtlasSDK

class OptionsSpec: QuickSpec {

    // swiftlint:disable:next function_body_length
    override func spec() {

        let clientId = "CLIENT_ID_SPEC"
        let salesChannel = "SALES_CHANNEL_SPEC"
        let interfaceLanguage = "fr"
        let useSandbox = true
        let emptyBundle = NSBundle()
        let testsBundle = NSBundle(forClass: OptionsSpec.self)

        describe("Options") {

            it("should initialize from given values") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel,
                    useSandbox: useSandbox,
                    interfaceLanguage: interfaceLanguage)

                expect(opts.clientId).to(equal(clientId))
                expect(opts.salesChannel).to(equal(salesChannel))
                expect(opts.interfaceLanguage).to(equal(interfaceLanguage))
                expect(opts.useSandboxEnvironment).to(equal(useSandbox))
            }

            it("should register authorization handler correctly in Injector") {
                let _ = Options(authorizationHandler: MockAuthorizationHandler())
                let authorizationHandler = try? Atlas.provide() as AuthorizationHandler

                expect(authorizationHandler).toNot(beNil())
            }

            it("should have no default language") {
                let opts = Options(infoBundle: emptyBundle)

                expect(opts.interfaceLanguage).to(beNil())
            }

            it("should fail with missing clientId") {
                let opts = Options(clientId: nil, salesChannel: salesChannel, interfaceLanguage: interfaceLanguage, infoBundle: emptyBundle)

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingClientId))
            }

            it("should fail with missing salesChannel") {
                let opts = Options(clientId: clientId, salesChannel: nil, interfaceLanguage: interfaceLanguage, infoBundle: emptyBundle)

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingSalesChannel))
            }

            it("should load Info.plist values automatically") {
                let opts = Options(infoBundle: testsBundle)

                expect(opts.clientId).to(equal("CLIENT_ID_PLIST"))
                expect(opts.salesChannel).to(equal("SALES_CHANNEL_PLIST"))
                expect(opts.interfaceLanguage).to(equal("en"))
                expect(opts.useSandboxEnvironment).to(beTrue())
            }

            it("should override values from Info.plist") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel,
                    useSandbox: useSandbox,
                    interfaceLanguage: interfaceLanguage,
                    infoBundle: testsBundle)

                expect(opts.clientId).to(equal(clientId))
                expect(opts.salesChannel).to(equal(salesChannel))
                expect(opts.interfaceLanguage).to(equal(interfaceLanguage))
                expect(opts.useSandboxEnvironment).to(equal(useSandbox))
            }

        }
    }

}
