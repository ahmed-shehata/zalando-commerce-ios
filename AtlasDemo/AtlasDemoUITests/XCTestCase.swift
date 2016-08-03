//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest

extension XCTestCase {

    func waitForElementToAppear(element: XCUIElement, timeout: NSTimeInterval,
        file: String = #file, line: UInt = #line, completion: (XCUIElement -> Void)?) {
            let existsPredicate = NSPredicate(format: "exists == true")
            expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)

            waitForExpectationsWithTimeout(timeout) { error in
                guard error == nil else {
                    self.recordFailureWithDescription("Failed to find \(element) after \(timeout) seconds.",
                        inFile: file, atLine: line, expected: true)
                    return
                }
                completion?(element)
            }
    }

    func waitForElementToAppearAndTap(element: XCUIElement, timeout: NSTimeInterval = 10,
        file: String = #file, line: UInt = #line) {
            waitForElementToAppear(element, timeout: timeout, file: file, line: line) { element in
                element.tap()
            }
    }

}
