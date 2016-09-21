//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeSpec: QuickSpec {

    override func spec() {
        let localizer = LocalizerProviderTypeMock()
        let viewModel = EditAddressViewModel(userAddress: nil, countryCode: "DE")

        describe("Edit Address") {
            it("should format field title") {
                expect(EditAddressField.Title.title(localizer)).to(equal("Title*"))
                expect(EditAddressField.FirstName.title(localizer)).to(equal("First Name*"))
                expect(EditAddressField.LastName.title(localizer)).to(equal("Last Name*"))
                expect(EditAddressField.Street.title(localizer)).to(equal("Street*"))
                expect(EditAddressField.Additional.title(localizer)).to(equal("Additional"))
                expect(EditAddressField.Packstation.title(localizer)).to(equal("Packstation*"))
                expect(EditAddressField.MemberID.title(localizer)).to(equal("Member ID*"))
                expect(EditAddressField.Zipcode.title(localizer)).to(equal("Zipcode*"))
                expect(EditAddressField.City.title(localizer)).to(equal("City*"))
                expect(EditAddressField.Country.title(localizer)).to(equal("Country*"))
            }

            it("should set view model data") {
                self.updateModelData(localizer, viewModel: viewModel)

                expect(viewModel.gender).to(equal(Gender.male))
                expect(viewModel.firstName).to(equal("John"))
                expect(viewModel.lastName).to(equal("Doe"))
                expect(viewModel.street).to(equal("Mollstr. 1"))
                expect(viewModel.additional).to(equal("C/O Zalando SE"))
                expect(viewModel.pickupPointId).to(equal("123"))
                expect(viewModel.pickupPointMemberId).to(equal("12345"))
                expect(viewModel.zip).to(equal("10178"))
                expect(viewModel.city).to(equal("Berlin"))
            }

            it("Should read from view model") {
                self.updateModelData(localizer, viewModel: viewModel)

                expect(EditAddressField.Title.value(viewModel, localizer: localizer)).to(equal("Mr"))
                expect(EditAddressField.FirstName.value(viewModel, localizer: localizer)).to(equal("John"))
                expect(EditAddressField.LastName.value(viewModel, localizer: localizer)).to(equal("Doe"))
                expect(EditAddressField.Street.value(viewModel, localizer: localizer)).to(equal("Mollstr. 1"))
                expect(EditAddressField.Additional.value(viewModel, localizer: localizer)).to(equal("C/O Zalando SE"))
                expect(EditAddressField.Packstation.value(viewModel, localizer: localizer)).to(equal("123"))
                expect(EditAddressField.MemberID.value(viewModel, localizer: localizer)).to(equal("12345"))
                expect(EditAddressField.Zipcode.value(viewModel, localizer: localizer)).to(equal("10178"))
                expect(EditAddressField.City.value(viewModel, localizer: localizer)).to(equal("Berlin"))
                expect(EditAddressField.Country.value(viewModel, localizer: localizer)).to(equal("Germany"))
            }
        }
    }

    private func updateModelData(localizer: LocalizerProviderType, viewModel: EditAddressViewModel) {
        EditAddressField.Title.updateModel(viewModel, withValue: "Mr", localizer: localizer)
        EditAddressField.FirstName.updateModel(viewModel, withValue: "John", localizer: localizer)
        EditAddressField.LastName.updateModel(viewModel, withValue: "Doe", localizer: localizer)
        EditAddressField.Street.updateModel(viewModel, withValue: "Mollstr. 1", localizer: localizer)
        EditAddressField.Additional.updateModel(viewModel, withValue: "C/O Zalando SE", localizer: localizer)
        EditAddressField.Packstation.updateModel(viewModel, withValue: "123", localizer: localizer)
        EditAddressField.MemberID.updateModel(viewModel, withValue: "12345", localizer: localizer)
        EditAddressField.Zipcode.updateModel(viewModel, withValue: "10178", localizer: localizer)
        EditAddressField.City.updateModel(viewModel, withValue: "Berlin", localizer: localizer)
    }

}
