//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeSpec: QuickSpec {

    override func spec() {
        Atlas.register { try! Localizer(localeIdentifier: "en_UK") as Localizer }
        let viewModel = AddressFormViewModel(equatableAddress: nil, countryCode: "DE")

        describe("Edit Address") {
            it("should format field title") {
                expect(AddressFormField.title.title).to(equal("Title*"))
                expect(AddressFormField.firstName.title).to(equal("First Name*"))
                expect(AddressFormField.lastName.title).to(equal("Last Name*"))
                expect(AddressFormField.street.title).to(equal("Street*"))
                expect(AddressFormField.additional.title).to(equal("Additional"))
                expect(AddressFormField.packstation.title).to(equal("Packstation*"))
                expect(AddressFormField.memberID.title).to(equal("Member ID*"))
                expect(AddressFormField.zipcode.title).to(equal("Zipcode*"))
                expect(AddressFormField.city.title).to(equal("City*"))
                expect(AddressFormField.country.title).to(equal("Country*"))
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

                expect(AddressFormField.title.value(viewModel)).to(equal("Mr"))
                expect(AddressFormField.firstName.value(viewModel)).to(equal("John"))
                expect(AddressFormField.lastName.value(viewModel)).to(equal("Doe"))
                expect(AddressFormField.street.value(viewModel)).to(equal("Mollstr. 1"))
                expect(AddressFormField.additional.value(viewModel)).to(equal("C/O Zalando SE"))
                expect(AddressFormField.packstation.value(viewModel)).to(equal("123"))
                expect(AddressFormField.memberID.value(viewModel)).to(equal("12345"))
                expect(AddressFormField.zipcode.value(viewModel)).to(equal("10178"))
                expect(AddressFormField.city.value(viewModel)).to(equal("Berlin"))
                expect(AddressFormField.country.value(viewModel)).to(equal("Germany"))
            }
        }
    }

    private func updateModelData(viewModel: AddressFormViewModel) {
        AddressFormField.title.updateModel(viewModel, withValue: "Mr")
        AddressFormField.firstName.updateModel(viewModel, withValue: "John")
        AddressFormField.lastName.updateModel(viewModel, withValue: "Doe")
        AddressFormField.street.updateModel(viewModel, withValue: "Mollstr. 1")
        AddressFormField.additional.updateModel(viewModel, withValue: "C/O Zalando SE")
        AddressFormField.packstation.updateModel(viewModel, withValue: "123")
        AddressFormField.memberID.updateModel(viewModel, withValue: "12345")
        AddressFormField.zipcode.updateModel(viewModel, withValue: "10178")
        AddressFormField.city.updateModel(viewModel, withValue: "Berlin")
    }

}
