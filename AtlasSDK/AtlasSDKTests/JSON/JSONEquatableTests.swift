//
//   Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONEquatableTests: JSONTestCase {

    func testBasicTypesEquality() {
        let lhs = json["equals", "lhs"]
        let rhs = json["equals", "rhs"]
        
        expect(lhs[0] == rhs[0]) == true
        expect(lhs[1] == rhs[1]) == true
        expect(lhs[2] == rhs[2]) == true
        expect(lhs[3] == rhs[3]) == true
        expect(lhs[4] == rhs[4]) == true
    }

    func testBasicTypesInequality() {
        let lhs = json["equals", "lhs"]
        let rhs = json["equals", "rhs"]

        expect(lhs[0] == rhs[1]) == false
        expect(lhs[1] == rhs[2]) == false
        expect(lhs[2] == rhs[3]) == false
        expect(lhs[3] == rhs[4]) == false
        expect(lhs[4] == rhs[0]) == false
    }

    func testDictionariesEquality() {
        let dict1 = json["equals", "dicts", "dict1"]
        let dict2 = json["equals", "dicts", "dict1"]
        let dict3 = json["equals", "dicts", "dict3"]

        expect(dict1 == dict2) == true
        expect(dict1 != dict3) == true
    }

    func testArraysEquality() {
        let lhs = json["equals", "lhs"]
        let rhs = json["equals", "rhs"]
        let arr = json["equals", "randomArray"]
        expect(lhs == rhs) == true
        expect(lhs != arr) == true
    }


}
