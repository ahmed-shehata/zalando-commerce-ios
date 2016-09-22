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
        let viewModel = AddressFormViewModel(equatableAddress: nil, countryCode: "DE")

        describe("Edit Address") {
            it("should format field title") {
                expect(AddressFormField.Title.title(localizer)).to(equal("Title"))
                expect(AddressFormField.FirstName.title(localizer)).to(equal("First Name"))
                expect(AddressFormField.LastName.title(localizer)).to(equal("Last Name"))
                expect(AddressFormField.Street.title(localizer)).to(equal("Street"))
                expect(AddressFormField.Additional.title(localizer)).to(equal("Additional"))
                expect(AddressFormField.Packstation.title(localizer)).to(equal("Packstation"))
                expect(AddressFormField.MemberID.title(localizer)).to(equal("Member ID"))
                expect(AddressFormField.Zipcode.title(localizer)).to(equal("Zipcode"))
                expect(AddressFormField.City.title(localizer)).to(equal("City"))
                expect(AddressFormField.Country.title(localizer)).to(equal("Country"))
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

                expect(AddressFormField.Title.value(viewModel, localizer: localizer)).to(equal("Mr"))
                expect(AddressFormField.FirstName.value(viewModel, localizer: localizer)).to(equal("John"))
                expect(AddressFormField.LastName.value(viewModel, localizer: localizer)).to(equal("Doe"))
                expect(AddressFormField.Street.value(viewModel, localizer: localizer)).to(equal("Mollstr. 1"))
                expect(AddressFormField.Additional.value(viewModel, localizer: localizer)).to(equal("C/O Zalando SE"))
                expect(AddressFormField.Packstation.value(viewModel, localizer: localizer)).to(equal("123"))
                expect(AddressFormField.MemberID.value(viewModel, localizer: localizer)).to(equal("12345"))
                expect(AddressFormField.Zipcode.value(viewModel, localizer: localizer)).to(equal("10178"))
                expect(AddressFormField.City.value(viewModel, localizer: localizer)).to(equal("Berlin"))
                expect(AddressFormField.Country.value(viewModel, localizer: localizer)).to(equal("Germany"))
            }
        }
    }

    private func updateModelData(localizer: LocalizerProviderType, viewModel: AddressFormViewModel) {
        AddressFormField.Title.updateModel(viewModel, withValue: "Mr", localizer: localizer)
        AddressFormField.FirstName.updateModel(viewModel, withValue: "John", localizer: localizer)
        AddressFormField.LastName.updateModel(viewModel, withValue: "Doe", localizer: localizer)
        AddressFormField.Street.updateModel(viewModel, withValue: "Mollstr. 1", localizer: localizer)
        AddressFormField.Additional.updateModel(viewModel, withValue: "C/O Zalando SE", localizer: localizer)
        AddressFormField.Packstation.updateModel(viewModel, withValue: "123", localizer: localizer)
        AddressFormField.MemberID.updateModel(viewModel, withValue: "12345", localizer: localizer)
        AddressFormField.Zipcode.updateModel(viewModel, withValue: "10178", localizer: localizer)
        AddressFormField.City.updateModel(viewModel, withValue: "Berlin", localizer: localizer)
    }

}
