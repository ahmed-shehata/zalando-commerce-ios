//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class BorderView: UIView {

    var topBorder: Bool = false
    var rightBorder: Bool = false
    var bottomBorder: Bool = false
    var leftBorder: Bool = false
    var leadingMargin: CGFloat = 0
    var trailingMarging: CGFloat = 0
    var borderColor: UIColor = .black {
        didSet {
            subviews.forEach { $0.backgroundColor = borderColor }
        }
    }

    fileprivate let onePixel = 1 / UIScreen.main.scale

    override func layoutSubviews() {
        super.layoutSubviews()
        removeAllSubviews()

        let totalMargin = leadingMargin + trailingMarging

        if topBorder {
            addView(CGRect(x: leadingMargin, y: 0, width: bounds.width - totalMargin, height: onePixel))
        }
        if rightBorder {
            addView(CGRect(x: bounds.width - onePixel, y: leadingMargin, width: onePixel, height: bounds.height - totalMargin))
        }
        if bottomBorder {
            addView(CGRect(x: leadingMargin, y: bounds.height - onePixel, width: bounds.width - totalMargin, height: onePixel))
        }
        if leftBorder {
            addView(CGRect(x: 0, y: leadingMargin, width: onePixel, height: bounds.height - totalMargin))
        }
    }

    fileprivate func addView(_ frame: CGRect) {
        let view = UIView(frame: frame)
        view.backgroundColor = borderColor
        addSubview(view)
    }

}
