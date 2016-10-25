//
//  Copyright © 2016 Zalando SE. All rights reserved.
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
        Keychain.write(value, forKey: testKey)
        expect(Keychain.read(forKey: self.testKey)).to(equal(value))
    }

    func testUpdateValue() {
        var value = "test_new_2"
        Keychain.write(value, forKey: testKey)
        expect(Keychain.read(forKey: self.testKey)).to(equal(value))

        value = "test_update_2"
        Keychain.write(value, forKey: testKey)
        expect(Keychain.read(forKey: self.testKey)).to(equal(value))
    }

    func testDeleteValue() {
        let value = "test_delete_it"
        Keychain.write(value, forKey: testKey)
        expect(Keychain.read(forKey: self.testKey)).to(equal(value))

        Keychain.delete(key: testKey)
        expect(Keychain.read(forKey: self.testKey)).to(beNil())
    }

    func testNilValue() {
        expect(Keychain.read(forKey: "test_new_4")).to(beNil())
    }

}
