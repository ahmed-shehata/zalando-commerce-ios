//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasCommons

class KeychainSpec: QuickSpec {

    override func spec() {

        describe("Keychain") {

            let testKey = "test-key"

            beforeEach {
                Keychain.delete(key: testKey)
            }

            it("should write value") {
                let value = "test_new_1"
                Keychain.write(value, forKey: testKey)
                expect(Keychain.read(forKey: testKey)).to(equal(value))
            }

            it("should update value") {
                var value = "test_new_2"
                Keychain.write(value, forKey: testKey)
                expect(Keychain.read(forKey: testKey)).to(equal(value))

                value = "test_update_2"
                Keychain.write(value, forKey: testKey)
                expect(Keychain.read(forKey: testKey)).to(equal(value))
            }

            it("should delete written value") {
                let value = "test_delete_it"
                Keychain.write(value, forKey: testKey)
                expect(Keychain.read(forKey: testKey)).to(equal(value))

                Keychain.delete(key: testKey)

                expect(Keychain.read(forKey: testKey)).to(beNil())
            }

            it("should return nil for not existing key") {
                expect(Keychain.read(forKey: "test_new_4")).to(beNil())
            }

        }
    }

}
