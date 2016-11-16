//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class OptionsTests: XCTestCase {

    let clientId = "CLIENT_ID_SPEC"
    let salesChannel = "SALES_CHANNEL_SPEC"
    let interfaceLanguage = "fr"
    let useSandbox = true
    let emptyBundle = NSBundle()
    let testsBundle = NSBundle(forClass: OptionsTests.self)

    func testInitialization() {
        let opts = Options(clientId: clientId,
                           salesChannel: salesChannel,
                           useSandbox: useSandbox,
                           interfaceLanguage: interfaceLanguage)

        expect(opts.clientId).to(equal(clientId))
        expect(opts.salesChannel).to(equal(salesChannel))
        expect(opts.interfaceLanguage).to(equal(interfaceLanguage))
        expect(opts.useSandboxEnvironment).to(equal(useSandbox))
    }

    func testNoDefaultLanguage() {
        let opts = Options(infoBundle: emptyBundle)
        expect(opts.interfaceLanguage).to(beNil())
    }

    func testMissingClientID() {
        let opts = Options(clientId: nil, salesChannel: salesChannel, interfaceLanguage: interfaceLanguage, infoBundle: emptyBundle)
        expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingClientId))
    }

    func testMissingSalesChannel() {
        let opts = Options(clientId: clientId, salesChannel: nil, interfaceLanguage: interfaceLanguage, infoBundle: emptyBundle)
        expect { try opts.validate() }.to(throwError(AtlasConfigurationError.missingSalesChannel))
    }

    func testLoadValuesFromInfoPlist() {
        let opts = Options(infoBundle: testsBundle)

        expect(opts.clientId).to(equal("CLIENT_ID_PLIST"))
        expect(opts.salesChannel).to(equal("SALES_CHANNEL_PLIST"))
        expect(opts.interfaceLanguage).to(equal("en"))
        expect(opts.useSandboxEnvironment).to(beTrue())
    }

    func testOverrideValuesFromInfoPlist() {
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
