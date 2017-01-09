//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest

extension XCUIElement {

    func scrollTo(element: XCUIElement) {
        while !element.exists {
            swipeUp()
        }
    }

}
