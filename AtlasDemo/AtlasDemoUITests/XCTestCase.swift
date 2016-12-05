//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest

extension XCTestCase {

    func wait(forElementToAppear element: XCUIElement, timeout: TimeInterval,
        file: String = #file, line: UInt = #line, completion: ((XCUIElement) -> Void)?) {
            let existsPredicate = NSPredicate(format: "exists == true")
            expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

            waitForExpectations(timeout: timeout) { error in
                guard error == nil else {
                    self.recordFailure(withDescription: "Failed to find \(element) after \(timeout) seconds.",
                        inFile: file, atLine: line, expected: true)
                    return
                }
                completion?(element)
            }
    }

    func waitForAppearAndTap(element: XCUIElement, timeout: TimeInterval = 10,
        file: String = #file, line: UInt = #line) {
            wait(forElementToAppear: element, timeout: timeout, file: file, line: line) { element in
                element.tap()
            }
    }

}
