//
//   Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasSDK

class OptionsSpec: QuickSpec {

    override func spec() {

        let clientId = "CLIENT_ID_SPEC"
        let salesChannel = "SALES_CHANNEL_SPEC"
        let countryCode = "FR"
        let interfaceLanguage = "de"
        let useSandbox = true

        describe("Options") {

            it("should initialize from given values") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel,
                    useSandbox: useSandbox,
                    countryCode: countryCode,
                    interfaceLanguage: interfaceLanguage)

                expect(opts.clientId).to(equal(clientId))
                expect(opts.salesChannel).to(equal(salesChannel))
                expect(opts.countryCode).to(equal(countryCode))
                expect(opts.useSandboxEnvironment).to(equal(useSandbox))
                expect(opts.interfaceLanguage).to(equal(interfaceLanguage))
            }

            it("should register authorization handler correctly in Injector") {
                let _ = Options(authorizationHandler: MockAuthorizationHandler())
                let authorizationHandler = try? Injector.provide() as AuthorizationHandler

                expect(authorizationHandler).toNot(beNil())
            }

            it("should fail with missing clientId") {
                let opts = Options(clientId: nil, salesChannel: salesChannel, countryCode: countryCode, infoBundle: NSBundle())

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingClientId))
            }

            it("should fail with missing salesChannel") {
                let opts = Options(clientId: clientId, salesChannel: nil, countryCode: countryCode, infoBundle: NSBundle())

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingSalesChannel))
            }

            it("should fail with missing countryCode") {
                let opts = Options(clientId: clientId, salesChannel: salesChannel, countryCode: nil, infoBundle: NSBundle())

                expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingCountryCode))
            }

            it("should return correct localeIdentifier") {
                let opts = Options(countryCode: "DE", interfaceLanguage: "en")

                expect(opts.localeIdentifier).to(equal("en_DE"))
            }

            it("should load Info.plist values automatically") {
                let infoBundle = NSBundle(forClass: OptionsSpec.self)
                let opts = Options(infoBundle: infoBundle)

                expect(opts.clientId).to(equal("CLIENT_ID_PLIST"))
                expect(opts.salesChannel).to(equal("SALES_CHANNEL_PLIST"))
                expect(opts.countryCode).to(equal("DE"))
                expect(opts.interfaceLanguage).to(equal("en"))
                expect(opts.useSandboxEnvironment).to(beTrue())
            }

            it("should override values from Info.plist") {
            }

        }
    }

}
