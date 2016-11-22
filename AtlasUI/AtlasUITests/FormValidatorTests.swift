//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class FormValidatorTests: XCTestCase {

    override func setUp() {
        super.setUp()

        AtlasUI.register { try! Localizer(localeIdentifier: "en_UK") as Localizer }
    }

    func testRequiredValidator() {
        let validator = FormValidator.required
        expect(validator.errorMessage("John")).to(beNil())
        expect(validator.errorMessage("")).to(equal("This field is required"))
        expect(validator.errorMessage(nil)).to(equal("This field is required"))
    }

    func testMinimumLengthValidator() {
        let validator = FormValidator.minLength(minLength: 3)
        expect(validator.errorMessage("John")).to(beNil())
        expect(validator.errorMessage("Joh")).to(beNil())
        expect(validator.errorMessage("Jo")).to(equal("Min length is 3"))
        expect(validator.errorMessage("")).to(equal("Min length is 3"))
        expect(validator.errorMessage(nil)).to(equal("Min length is 3"))
    }

    func testMaximumLengthValidator() {
        let validator = FormValidator.maxLength(maxLength: 4)
        expect(validator.errorMessage("John")).to(beNil())
        expect(validator.errorMessage("Joh")).to(beNil())
        expect(validator.errorMessage("")).to(beNil())
        expect(validator.errorMessage(nil)).to(beNil())
        expect(validator.errorMessage("John Doe")).to(equal("Max length is 4"))
    }

    func testExactLengthValidator() {
        let validator = FormValidator.exactLength(length: 4)
        expect(validator.errorMessage("John")).to(beNil())
        expect(validator.errorMessage("John Doe")).to(equal("Required length is 4"))
        expect(validator.errorMessage("Joh")).to(equal("Required length is 4"))
        expect(validator.errorMessage("")).to(equal("Required length is 4"))
        expect(validator.errorMessage(nil)).to(equal("Required length is 4"))
    }

    func testPatternValidator() {
        let validator = FormValidator.pattern(pattern: FormValidator.namePattern, errorMessage: "formValidation.pattern.name")
        expect(validator.errorMessage("John")).to(beNil())
        expect(validator.errorMessage("John Doe")).to(beNil())
        expect(validator.errorMessage("John-Doe")).to(beNil())
        expect(validator.errorMessage("")).to(beNil())
        expect(validator.errorMessage(nil)).to(beNil())
        expect(validator.errorMessage("John*Doe")).to(equal("Please only use the characters (A-z) in this field"))
    }

    func testNumbersOnlyValidator() {
        let validator = FormValidator.numbersOnly
        expect(validator.errorMessage("12345")).to(beNil())
        expect(validator.errorMessage("John1")).to(equal("Only numbers are allowed"))
    }

}
