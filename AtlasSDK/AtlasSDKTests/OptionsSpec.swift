//
//   Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class OptionsSpec: QuickSpec {

    // swiftlint:disable:next function_body_length
    override func spec() {

        let clientId = "CLIENT_ID_SPEC"
        let salesChannel = "SALES_CHANNEL_SPEC"
        let localeIdentifier = "fr_FR"
        let useSandbox = true
        let emptyBundle = NSBundle(forClass: OptionsSpec.self)

        describe("Options") {

            it("should initialize from given values") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel,
                    useSandbox: useSandbox,
                    localeIdentifier: localeIdentifier)

                expect(opts.clientId).to(equal(clientId))
                expect(opts.salesChannel).to(equal(salesChannel))
                expect(opts.localeIdentifier).to(equal(localeIdentifier))
                expect(opts.useSandboxEnvironment).to(equal(useSandbox))
            }

            it("should register authorization handler correctly in Injector") {
                let _ = Options(authorizationHandler: MockAuthorizationHandler())
                let authorizationHandler = try? Injector.provide() as AuthorizationHandler

                expect(authorizationHandler).toNot(beNil())
            }

            it("should have no default localeIdentifier") {
                let opts = Options(infoBundle: emptyBundle)

                expect(opts.localeIdentifier).to(beNil())
            }

            it("should fail with missing clientId") {
                let opts = Options(clientId: nil, salesChannel: salesChannel, localeIdentifier: localeIdentifier, infoBundle: NSBundle())

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingClientId))
            }

            it("should fail with missing salesChannel") {
                let opts = Options(clientId: clientId, salesChannel: nil, localeIdentifier: localeIdentifier, infoBundle: NSBundle())

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingSalesChannel))
            }

            it("should load Info.plist values automatically") {
                let opts = Options(infoBundle: emptyBundle)

                expect(opts.clientId).to(equal("CLIENT_ID_PLIST"))
                expect(opts.salesChannel).to(equal("SALES_CHANNEL_PLIST"))
                expect(opts.localeIdentifier).to(equal("en_DE"))
                expect(opts.useSandboxEnvironment).to(beTrue())
            }

            it("should override values from Info.plist") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel,
                    useSandbox: useSandbox,
                    localeIdentifier: localeIdentifier,
                    infoBundle: emptyBundle)

                expect(opts.clientId).to(equal(clientId))
                expect(opts.salesChannel).to(equal(salesChannel))
                expect(opts.localeIdentifier).to(equal(localeIdentifier))
                expect(opts.useSandboxEnvironment).to(equal(useSandbox))
            }

        }
    }

}
