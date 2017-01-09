//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class EditAddressTypeTests: UITestCase {

    var dataModel: AddressFormDataModel!

    override func setUp() {
        super.setUp()
        dataModel = AddressFormDataModel(equatableAddress: nil, countryCode: "DE")
        update(dataModel: dataModel)
    }

    func testFieldTitle() {
        expect(AddressFormField.title.title) == "Title*"
        expect(AddressFormField.firstName.title) == "First Name*"
        expect(AddressFormField.lastName.title) == "Last Name*"
        expect(AddressFormField.street.title) == "Street*"
        expect(AddressFormField.additional.title) == "Additional"
        expect(AddressFormField.packstation.title) == "Packstation*"
        expect(AddressFormField.memberID.title) == "Member ID*"
        expect(AddressFormField.zipcode.title) == "Zipcode*"
        expect(AddressFormField.city.title) == "City*"
        expect(AddressFormField.country.title) == "Country*"
    }

    func testSettingDataModelData() {
        expect(self.dataModel.gender) == Gender.male
        expect(self.dataModel.firstName) == "John"
        expect(self.dataModel.lastName) == "Doe"
        expect(self.dataModel.street) == "Mollstr. 1"
        expect(self.dataModel.additional) == "C/O Zalando SE"
        expect(self.dataModel.pickupPointId) == "123"
        expect(self.dataModel.pickupPointMemberId) == "12345"
        expect(self.dataModel.zip) == "10178"
        expect(self.dataModel.city) == "Berlin"
    }

    func testReadingFromDataModel() {
        expect(self.dataModel.value(forField: .title)) == "Mr"
        expect(self.dataModel.value(forField: .firstName)) == "John"
        expect(self.dataModel.value(forField: .lastName)) == "Doe"
        expect(self.dataModel.value(forField: .street)) == "Mollstr. 1"
        expect(self.dataModel.value(forField: .additional)) == "C/O Zalando SE"
        expect(self.dataModel.value(forField: .packstation)) == "123"
        expect(self.dataModel.value(forField: .memberID)) == "12345"
        expect(self.dataModel.value(forField: .zipcode)) == "10178"
        expect(self.dataModel.value(forField: .city)) == "Berlin"
        expect(self.dataModel.value(forField: .country)) == "Germany"
    }

}

extension EditAddressTypeTests {

    fileprivate func update(dataModel: AddressFormDataModel) {
        dataModel.update(value: "Mr", fromField: .title)
        dataModel.update(value: "John", fromField: .firstName)
        dataModel.update(value: "Doe", fromField: .lastName)
        dataModel.update(value: "Mollstr. 1", fromField: .street)
        dataModel.update(value: "C/O Zalando SE", fromField: .additional)
        dataModel.update(value: "123", fromField: .packstation)
        dataModel.update(value: "12345", fromField: .memberID)
        dataModel.update(value: "10178", fromField: .zipcode)
        dataModel.update(value: "Berlin", fromField: .city)
    }

}
