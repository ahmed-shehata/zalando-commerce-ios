//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble
import AtlasSDK

@testable import AtlasUI

class FormValidatorTests: UITestCase {

    func testRequiredValidator() {
        let validator = FormValidator.required
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "")) == "This field is required"
        expect(validator.rejectionReason(for: nil)) == "This field is required"
    }

    func testMinimumLengthValidator() {
        let validator = FormValidator.minLength(minLength: 3)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "Joh")).to(beNil())
        expect(validator.rejectionReason(for: "Jo")) == "Min length is 3"
        expect(validator.rejectionReason(for: "")) == "Min length is 3"
        expect(validator.rejectionReason(for: nil)) == "Min length is 3"
    }

    func testMaximumLengthValidator() {
        let validator = FormValidator.maxLength(maxLength: 4)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "Joh")).to(beNil())
        expect(validator.rejectionReason(for: "")).to(beNil())
        expect(validator.rejectionReason(for: nil)).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")) == "Max length is 4"
    }

    func testExactLengthValidator() {
        let validator = FormValidator.exactLength(length: 4)
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")) == "Required length is 4"
        expect(validator.rejectionReason(for: "Joh")) == "Required length is 4"
        expect(validator.rejectionReason(for: "")) == "Required length is 4"
        expect(validator.rejectionReason(for: nil)) == "Required length is 4"
    }

    func testPatternValidator() {
        let validator = FormValidator.pattern(pattern: FormValidator.namePattern, errorMessage: "formValidation.pattern.name")
        expect(validator.rejectionReason(for: "John")).to(beNil())
        expect(validator.rejectionReason(for: "John Doe")).to(beNil())
        expect(validator.rejectionReason(for: "John-Doe")).to(beNil())
        expect(validator.rejectionReason(for: "")).to(beNil())
        expect(validator.rejectionReason(for: nil)).to(beNil())
        expect(validator.rejectionReason(for: "John*Doe")) == "Please only use the characters (A-z) in this field"
    }

    func testNumbersOnlyValidator() {
        let validator = FormValidator.numbersOnly
        expect(validator.rejectionReason(for: "12345")).to(beNil())
        expect(validator.rejectionReason(for: "John1")) == "Only numbers are allowed"
    }

}
