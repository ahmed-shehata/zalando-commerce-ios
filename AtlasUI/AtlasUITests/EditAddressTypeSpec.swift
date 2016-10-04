//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeSpec: QuickSpec {

    override func spec() {
        Atlas.register { try! Localizer(localeIdentifier: "en_UK") as Localizer } // swiftlint:disable:this force_try
        let viewModel = AddressFormViewModel(equatableAddress: nil, countryCode: "DE")

        describe("Edit Address") {
            it("should format field title") {
                expect(AddressFormField.Title.title).to(equal("Title*"))
                expect(AddressFormField.FirstName.title).to(equal("First Name*"))
                expect(AddressFormField.LastName.title).to(equal("Last Name*"))
                expect(AddressFormField.Street.title).to(equal("Street*"))
                expect(AddressFormField.Additional.title).to(equal("Additional"))
                expect(AddressFormField.Packstation.title).to(equal("Packstation*"))
                expect(AddressFormField.MemberID.title).to(equal("Member ID*"))
                expect(AddressFormField.Zipcode.title).to(equal("Zipcode*"))
                expect(AddressFormField.City.title).to(equal("City*"))
                expect(AddressFormField.Country.title).to(equal("Country*"))
            }

            it("should set view model data") {
                self.updateModelData(viewModel)

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
                self.updateModelData(viewModel)

                expect(AddressFormField.Title.value(viewModel)).to(equal("Mr"))
                expect(AddressFormField.FirstName.value(viewModel)).to(equal("John"))
                expect(AddressFormField.LastName.value(viewModel)).to(equal("Doe"))
                expect(AddressFormField.Street.value(viewModel)).to(equal("Mollstr. 1"))
                expect(AddressFormField.Additional.value(viewModel)).to(equal("C/O Zalando SE"))
                expect(AddressFormField.Packstation.value(viewModel)).to(equal("123"))
                expect(AddressFormField.MemberID.value(viewModel)).to(equal("12345"))
                expect(AddressFormField.Zipcode.value(viewModel)).to(equal("10178"))
                expect(AddressFormField.City.value(viewModel)).to(equal("Berlin"))
                expect(AddressFormField.Country.value(viewModel)).to(equal("Germany"))
            }
        }
    }

    private func updateModelData(viewModel: AddressFormViewModel) {
        AddressFormField.Title.updateModel(viewModel, withValue: "Mr")
        AddressFormField.FirstName.updateModel(viewModel, withValue: "John")
        AddressFormField.LastName.updateModel(viewModel, withValue: "Doe")
        AddressFormField.Street.updateModel(viewModel, withValue: "Mollstr. 1")
        AddressFormField.Additional.updateModel(viewModel, withValue: "C/O Zalando SE")
        AddressFormField.Packstation.updateModel(viewModel, withValue: "123")
        AddressFormField.MemberID.updateModel(viewModel, withValue: "12345")
        AddressFormField.Zipcode.updateModel(viewModel, withValue: "10178")
        AddressFormField.City.updateModel(viewModel, withValue: "Berlin")
    }

}
