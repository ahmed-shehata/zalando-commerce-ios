//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class BorderView: UIView {

    var topBorder: Bool = false {
        didSet { setNeedsLayout() }
    }
    var rightBorder: Bool = false {
        didSet { setNeedsLayout() }
    }
    var bottomBorder: Bool = false {
        didSet { setNeedsLayout() }
    }
    var leftBorder: Bool = false {
        didSet { setNeedsLayout() }
    }
    var leadingMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    var trailingMargin: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    var borderColor: UIColor = .black {
        didSet {
            setNeedsLayout()
            subviews.forEach { $0.backgroundColor = borderColor }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        removeAllSubviews()

        let onePixel = 1 / UIScreen.main.scale
        let totalMargin = leadingMargin + trailingMargin

        if topBorder {
            addView(x: leadingMargin, y: 0, width: bounds.width - totalMargin, height: onePixel)
        }
        if rightBorder {
            addView(x: bounds.width - onePixel, y: leadingMargin, width: onePixel, height: bounds.height - totalMargin)
        }
        if bottomBorder {
            addView(x: leadingMargin, y: bounds.height - onePixel, width: bounds.width - totalMargin, height: onePixel)
        }
        if leftBorder {
            addView(x: 0, y: leadingMargin, width: onePixel, height: bounds.height - totalMargin)
        }
    }

    // swiftlint:disable:next variable_name
    fileprivate func addView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = borderColor
        addSubview(view)
    }

}
