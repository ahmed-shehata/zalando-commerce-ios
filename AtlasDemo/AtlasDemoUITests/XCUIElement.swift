//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest

extension XCUIElement {

    func scrollToElement(element: XCUIElement) {
        while !element.exists {
            swipeUp()
        }
    }

}
