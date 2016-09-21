//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasUI

class FormValidatorSpec: QuickSpec {

    override func spec() {
        let localizer = LocalizerProviderTypeMock()

        describe("FormValidator") {
            it("Should check on required value") {
                let validator = FormValidator.Required
                expect(validator.errorMessage("John", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("", localizer: localizer)).to(equal("This field is required"))
                expect(validator.errorMessage(nil, localizer: localizer)).to(equal("This field is required"))
            }

            it("Should check on Minimum Length") {
                let validator = FormValidator.MinLength(minLength: 3)
                expect(validator.errorMessage("John", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("Joh", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("Jo", localizer: localizer)).to(equal("Min length is 3"))
                expect(validator.errorMessage("", localizer: localizer)).to(equal("Min length is 3"))
                expect(validator.errorMessage(nil, localizer: localizer)).to(equal("Min length is 3"))
            }

            it("Should check on Maximum Length") {
                let validator = FormValidator.MaxLength(maxLength: 4)
                expect(validator.errorMessage("John", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("Joh", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("", localizer: localizer)).to(beNil())
                expect(validator.errorMessage(nil, localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John Doe", localizer: localizer)).to(equal("Max length is 4"))
            }

            it("Should check on Exact Length") {
                let validator = FormValidator.ExactLength(length: 4)
                expect(validator.errorMessage("John", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John Doe", localizer: localizer)).to(equal("Required length is 4"))
                expect(validator.errorMessage("Joh", localizer: localizer)).to(equal("Required length is 4"))
                expect(validator.errorMessage("", localizer: localizer)).to(equal("Required length is 4"))
                expect(validator.errorMessage(nil, localizer: localizer)).to(equal("Required length is 4"))
            }

            it("Should check on Pattern") {
                let validator = FormValidator.Pattern(pattern: "^[' \\w-]+$")
                expect(validator.errorMessage("John", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John Doe", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John-Doe", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("", localizer: localizer)).to(beNil())
                expect(validator.errorMessage(nil, localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John*Doe", localizer: localizer)).to(equal("Invalid value"))
            }

            it("Should check on NumbersOnly") {
                let validator = FormValidator.NumbersOnly
                expect(validator.errorMessage("12345", localizer: localizer)).to(beNil())
                expect(validator.errorMessage("John", localizer: localizer)).to(equal("Only numbers are allowed"))
            }
        }
    }

}
