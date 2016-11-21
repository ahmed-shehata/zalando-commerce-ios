//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeTests: XCTestCase {

    var dataModel: AddressFormDataModel!

    override func setUp() {
        super.setUp()

        AtlasUI.register { try! Localizer(localeIdentifier: "en_UK") as Localizer }
        dataModel = AddressFormDataModel(equatableAddress: nil, countryCode: "DE")
        updateModelData(dataModel)
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

    func testSettingDataModelData() {
        expect(self.dataModel.gender).to(equal(Gender.male))
        expect(self.dataModel.firstName).to(equal("John"))
        expect(self.dataModel.lastName).to(equal("Doe"))
        expect(self.dataModel.street).to(equal("Mollstr. 1"))
        expect(self.dataModel.additional).to(equal("C/O Zalando SE"))
        expect(self.dataModel.pickupPointId).to(equal("123"))
        expect(self.dataModel.pickupPointMemberId).to(equal("12345"))
        expect(self.dataModel.zip).to(equal("10178"))
        expect(self.dataModel.city).to(equal("Berlin"))
    }

    func testReadingFromDataModel() {
        expect(AddressFormField.title.value(self.dataModel)).to(equal("Mr"))
        expect(AddressFormField.firstName.value(self.dataModel)).to(equal("John"))
        expect(AddressFormField.lastName.value(self.dataModel)).to(equal("Doe"))
        expect(AddressFormField.street.value(self.dataModel)).to(equal("Mollstr. 1"))
        expect(AddressFormField.additional.value(self.dataModel)).to(equal("C/O Zalando SE"))
        expect(AddressFormField.packstation.value(self.dataModel)).to(equal("123"))
        expect(AddressFormField.memberID.value(self.dataModel)).to(equal("12345"))
        expect(AddressFormField.zipcode.value(self.dataModel)).to(equal("10178"))
        expect(AddressFormField.city.value(self.dataModel)).to(equal("Berlin"))
        expect(AddressFormField.country.value(self.dataModel)).to(equal("Germany"))
    }

}

extension EditAddressTypeTests {

    private func updateModelData(dataModel: AddressFormDataModel) {
        AddressFormField.title.updateModel(dataModel, withValue: "Mr")
        AddressFormField.firstName.updateModel(dataModel, withValue: "John")
        AddressFormField.lastName.updateModel(dataModel, withValue: "Doe")
        AddressFormField.street.updateModel(dataModel, withValue: "Mollstr. 1")
        AddressFormField.additional.updateModel(dataModel, withValue: "C/O Zalando SE")
        AddressFormField.packstation.updateModel(dataModel, withValue: "123")
        AddressFormField.memberID.updateModel(dataModel, withValue: "12345")
        AddressFormField.zipcode.updateModel(dataModel, withValue: "10178")
        AddressFormField.city.updateModel(dataModel, withValue: "Berlin")
    }

}
