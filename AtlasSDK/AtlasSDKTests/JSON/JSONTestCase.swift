//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class JSONTestCase: XCTestCase {

    var json: JSON!

    override func setUp() {
        super.setUp()

        loadTestsFile()
    }

    func equalJson<T: Equatable>(rawObjectAtPath path: JSONSubscript...) -> MatcherFunc<T?> {
        return MatcherFunc { actualExpression, failureMessage in
            guard let jsonValue = self.json[path]?.rawObject as? T
                else { return false }
            failureMessage.postfixMessage = "equal <\(jsonValue)>"
            if let actualValue = try actualExpression.evaluate() {
                return actualValue == jsonValue
            } else {
                return false
            }
        }
    }

    private func loadTestsFile() {
        let bundle = Bundle(for: type(of: self))
        let fileURL = bundle.url(forResource: "JSONTests", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        json = try! JSON(data: data)
    }

}
