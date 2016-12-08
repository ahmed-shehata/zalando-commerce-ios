//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI

class CheckoutSummaryOrderStackViewTests: XCTestCase {

    let window = UIWindow()
    var scrollView: UIScrollView!
    var stackView: CheckoutSummaryOrderStackView!

    override func setUp() {
        super.setUp()

        stackView = CheckoutSummaryOrderStackView(frame: window.bounds)
        stackView.axis = .vertical
        stackView.buildView()
        stackView.configure(viewModel: "1234567")

        let innerView = UIView(frame: window.bounds)
        innerView.addSubview(stackView)
        stackView.fillInSuperview()

        scrollView = UIScrollView(frame: window.bounds)
        scrollView.addSubview(innerView)
        innerView.fillInSuperview()

        window.addSubview(scrollView)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        scrollView.fillInSuperview()
    }

    func testSaveImage() {
        expect(self.stackView.saveImageContainer.superview).toNotEventually(beNil())

        guard
            let target = stackView.saveImageButton.allTargets.first,
            let action = stackView.saveImageButton.actions(forTarget: target, forControlEvent: .touchUpInside)?.first else { return fail() }

        UIApplication.shared.sendAction(Selector(action), to: target, from: nil, for: nil)
        expect(self.stackView.imageSavedLabel.alpha).toEventually(equal(1), timeout: 1)
    }

}
