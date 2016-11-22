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
        update(dataModel: dataModel)
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
        expect(self.dataModel.value(forField: .title)).to(equal("Mr"))
        expect(self.dataModel.value(forField: .firstName)).to(equal("John"))
        expect(self.dataModel.value(forField: .lastName)).to(equal("Doe"))
        expect(self.dataModel.value(forField: .street)).to(equal("Mollstr. 1"))
        expect(self.dataModel.value(forField: .additional)).to(equal("C/O Zalando SE"))
        expect(self.dataModel.value(forField: .packstation)).to(equal("123"))
        expect(self.dataModel.value(forField: .memberID)).to(equal("12345"))
        expect(self.dataModel.value(forField: .zipcode)).to(equal("10178"))
        expect(self.dataModel.value(forField: .city)).to(equal("Berlin"))
        expect(self.dataModel.value(forField: .country)).to(equal("Germany"))
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
