//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasUI
@testable import AtlasSDK

class FormValidatorSpec: QuickSpec {

    override func spec() {
        Atlas.register { try! Localizer(localeIdentifier: "en_UK") as Localizer } // swiftlint:disable:this force_try

        describe("FormValidator") {
            it("Should check on required value") {
                let validator = FormValidator.Required
                expect(validator.errorMessage("John")).to(beNil())
                expect(validator.errorMessage("")).to(equal("This field is required"))
                expect(validator.errorMessage(nil)).to(equal("This field is required"))
            }

            it("Should check on Minimum Length") {
                let validator = FormValidator.MinLength(minLength: 3)
                expect(validator.errorMessage("John")).to(beNil())
                expect(validator.errorMessage("Joh")).to(beNil())
                expect(validator.errorMessage("Jo")).to(equal("Min length is 3"))
                expect(validator.errorMessage("")).to(equal("Min length is 3"))
                expect(validator.errorMessage(nil)).to(equal("Min length is 3"))
            }

            it("Should check on Maximum Length") {
                let validator = FormValidator.MaxLength(maxLength: 4)
                expect(validator.errorMessage("John")).to(beNil())
                expect(validator.errorMessage("Joh")).to(beNil())
                expect(validator.errorMessage("")).to(beNil())
                expect(validator.errorMessage(nil)).to(beNil())
                expect(validator.errorMessage("John Doe")).to(equal("Max length is 4"))
            }

            it("Should check on Exact Length") {
                let validator = FormValidator.ExactLength(length: 4)
                expect(validator.errorMessage("John")).to(beNil())
                expect(validator.errorMessage("John Doe")).to(equal("Required length is 4"))
                expect(validator.errorMessage("Joh")).to(equal("Required length is 4"))
                expect(validator.errorMessage("")).to(equal("Required length is 4"))
                expect(validator.errorMessage(nil)).to(equal("Required length is 4"))
            }

            it("Should check on Pattern") {
                let validator = FormValidator.Pattern(pattern: FormValidator.namePattern, errorMessage: "Form.validation.pattern.name")
                expect(validator.errorMessage("John")).to(beNil())
                expect(validator.errorMessage("John Doe")).to(beNil())
                expect(validator.errorMessage("John-Doe")).to(beNil())
                expect(validator.errorMessage("")).to(beNil())
                expect(validator.errorMessage(nil)).to(beNil())
                expect(validator.errorMessage("John*Doe")).to(equal("Please only use the characters (A-z) in this field"))
            }

            it("Should check on NumbersOnly") {
                let validator = FormValidator.NumbersOnly
                expect(validator.errorMessage("12345")).to(beNil())
                expect(validator.errorMessage("John")).to(equal("Only numbers are allowed"))
            }
        }
    }

}
