//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceUI

class UIViewTests: XCTestCase {

    let window = UIWindow()

    override func setUp() {
        super.setUp()
        window.makeKeyAndVisible()
    }

    func testScreenshot() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let image = view.takeScreenshot()
        expect(image).toNot(beNil())
        expect(image?.size) == CGSize(width: 100, height: 100)
    }

    func testFillInSuperview() {
        let view = UIView()
        window.addSubview(view)
        view.fillInSuperview()
        expect(view.frame).toEventually(equal(window.bounds))
    }

    func testSnapToSuperview() {
        let view = UIView()
        window.addSubview(view)
        view.snap(toSuperview: .top)
        view.snap(toSuperview: .right)
        view.snap(toSuperview: .bottom, constant: -10)
        view.snap(toSuperview: .left, constant: 10)
        expect(view.frame).toEventually(equal(CGRect(x: 10, y: 0, width: window.bounds.width - 10, height: window.bounds.height - 10)))
    }

}
