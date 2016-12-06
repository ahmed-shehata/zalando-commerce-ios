//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasMockAPI
import AtlasSDK

@testable import AtlasUI

class FormValidatorTests: XCTestCase {


    override class func setUp() {
        super.setUp()
        try! AtlasMockAPI.startServer()

        waitUntil(timeout: 10) { done in
            let opts = Options.forTests(interfaceLanguage: "en")
            AtlasUI.configure(options: opts) { result in
                if case let .failure(error) = result {
                    fail(String(describing: error))
                }
                done()
            }
        }
    }

    override class func tearDown() {
        super.tearDown()
        try! AtlasMockAPI.stopServer()
    }

    func testRequiredValidator() {
        let validator = FormValidator.required
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "")).to(equal("This field is required"))
        expect(validator.rejectionReason(for: nil)).to(equal("This field is required"))
    }

    func testMinimumLengthValidator() {
        let validator = FormValidator.minLength(minLength: 3)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "Joh")).to(beNil())
        expect(validator.rejectionReason(for: "Jo")).to(equal("Min length is 3"))
        expect(validator.rejectionReason(for: "")).to(equal("Min length is 3"))
        expect(validator.rejectionReason(for: nil)).to(equal("Min length is 3"))
    }

    func testMaximumLengthValidator() {
        let validator = FormValidator.maxLength(maxLength: 4)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "Joh")).to(beNil())
        expect(validator.rejectionReason(for: "")).to(beNil())
        expect(validator.rejectionReason(for: nil)).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")).to(equal("Max length is 4"))
    }

    func testExactLengthValidator() {
        let validator = FormValidator.exactLength(length: 4)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")).to(equal("Required length is 4"))
        expect(validator.rejectionReason(for: "Joh")).to(equal("Required length is 4"))
        expect(validator.rejectionReason(for: "")).to(equal("Required length is 4"))
        expect(validator.rejectionReason(for: nil)).to(equal("Required length is 4"))
    }

    func testPatternValidator() {
        let validator = FormValidator.pattern(pattern: FormValidator.namePattern, errorMessage: "formValidation.pattern.name")
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")).to(beNil())
        expect(validator.rejectionReason(for: "John-Doe")).to(beNil())
        expect(validator.rejectionReason(for: "")).to(beNil())
        expect(validator.rejectionReason(for: nil)).to(beNil())
        expect(validator.rejectionReason(for: "John*Doe")).to(equal("Please only use the characters (A-z) in this field"))
    }

    func testNumbersOnlyValidator() {
        let validator = FormValidator.numbersOnly
        expect(validator.rejectionReason(for: "12345")).to(beNil())
        expect(validator.rejectionReason(for: "John1")).to(equal("Only numbers are allowed"))
    }

}
