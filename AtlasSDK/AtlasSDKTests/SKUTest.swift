//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class SKUTest: XCTestCase {

    let modelSKUValue = "ABC123DEF"
    let configSKUValue = "ABC123DEF-V00"
    let simpleSKUValue = "ABC123DEF-V1112345A1"

    func testValidValueModelSKU() {
        let sku = ModelSKU(value: modelSKUValue)
        expect(sku.isValid) == true
        expect(sku.value) == modelSKUValue
    }

    func testValidValueConfigSKU() {
        let sku = ConfigSKU(value: configSKUValue)
        expect(sku.isValid) == true
        expect(sku.value) == configSKUValue
    }

    func testValidValueSimpleSKU() {
        let sku = SimpleSKU(value: simpleSKUValue)
        expect(sku.isValid) == true
        expect(sku.value) == simpleSKUValue
    }

    func testInvalidValueModelSKU() {
        let sku = ModelSKU(value: configSKUValue)
        expect(sku.isValid) == false
        expect(sku.value) == configSKUValue
    }

    func testValidValidationModelSKU() {
        expect {
            try ModelSKU(validate: self.modelSKUValue)
        }.toNot(throwError())
    }

    func testInvalidPatternModelSKU() {
        expect {
            try ModelSKU(validate: self.configSKUValue)
        }.to(throwError(SKUError.invalidPattern))
    }

    func testNoValueModelSKU() {
        expect {
            try ModelSKU(validate: nil)
        }.to(throwError(SKUError.noValue))
    }

    func testCorrectConversion() {
        let simpleSKU = SimpleSKU(value: simpleSKUValue)
        expect {
            try ModelSKU(from: simpleSKU)
        }.toNot(throwError())
    }

    func testInvalidConversion() {
        let modelSKU = ModelSKU(value: modelSKUValue)
        expect {
            try SimpleSKU(from: modelSKU)
        }.to(throwError(SKUError.invalidConversion))
    }

    func testEquality() {
        let sku1 = ModelSKU(value: modelSKUValue)
        let sku2 = ModelSKU(value: modelSKUValue)
        expect(sku1) == sku2
    }

    func testEmptySKU() {
        let emptySKU = ModelSKU.empty
        expect(emptySKU.isValid) == false
        expect(emptySKU.value) == ""
    }

}
