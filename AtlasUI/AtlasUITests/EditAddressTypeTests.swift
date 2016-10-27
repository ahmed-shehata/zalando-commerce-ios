//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeTests: XCTestCase {

    var viewModel: AddressFormViewModel!

    override func setUp() {
        super.setUp()

        Atlas.register { try! Localizer(localeIdentifier: "en_UK") as Localizer }
        viewModel = AddressFormViewModel(equatableAddress: nil, countryCode: "DE")
        updateModelData(viewModel)
    }

    func testFieldTitle() {
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

    func testSettingViewModelData() {
        expect(self.viewModel.gender).to(equal(Gender.male))
        expect(self.viewModel.firstName).to(equal("John"))
        expect(self.viewModel.lastName).to(equal("Doe"))
        expect(self.viewModel.street).to(equal("Mollstr. 1"))
        expect(self.viewModel.additional).to(equal("C/O Zalando SE"))
        expect(self.viewModel.pickupPointId).to(equal("123"))
        expect(self.viewModel.pickupPointMemberId).to(equal("12345"))
        expect(self.viewModel.zip).to(equal("10178"))
        expect(self.viewModel.city).to(equal("Berlin"))
    }

    func testReadingFromViewModel() {
        expect(AddressFormField.title.value(self.viewModel)).to(equal("Mr"))
        expect(AddressFormField.firstName.value(self.viewModel)).to(equal("John"))
        expect(AddressFormField.lastName.value(self.viewModel)).to(equal("Doe"))
        expect(AddressFormField.street.value(self.viewModel)).to(equal("Mollstr. 1"))
        expect(AddressFormField.additional.value(self.viewModel)).to(equal("C/O Zalando SE"))
        expect(AddressFormField.packstation.value(self.viewModel)).to(equal("123"))
        expect(AddressFormField.memberID.value(self.viewModel)).to(equal("12345"))
        expect(AddressFormField.zipcode.value(self.viewModel)).to(equal("10178"))
        expect(AddressFormField.city.value(self.viewModel)).to(equal("Berlin"))
        expect(AddressFormField.country.value(self.viewModel)).to(equal("Germany"))
    }

}

extension EditAddressTypeTests {

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
