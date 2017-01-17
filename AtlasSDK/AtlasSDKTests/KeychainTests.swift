//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasSDK

class KeychainTests: XCTestCase {

    let testKey = "test-key"

    override func setUp() {
        super.setUp()
        Keychain.delete(key: testKey)
    }

    func testWriteValue() {
        let value = "test_new_1"
        try! Keychain.write(value: value, forKey: testKey)
        expect(Keychain.read(key: self.testKey)) == value
    }

    func testUpdateValue() {
        var value = "test_new_2"
        try! Keychain.write(value: value, forKey: testKey)
        expect(Keychain.read(key: self.testKey)) == value

        value = "test_update_2"
        try! Keychain.write(value: value, forKey: testKey)
        expect(Keychain.read(key: self.testKey)) == value
    }

    func testDeleteValue() {
        let value = "test_delete_it"
        try! Keychain.write(value: value, forKey: testKey)
        expect(Keychain.read(key: self.testKey)) == value

        Keychain.delete(key: testKey)
        expect(Keychain.read(key: self.testKey)).to(beNil())
    }

    func testNilValue() {
        expect(Keychain.read(key: "test_new_4")).to(beNil())
    }

}
