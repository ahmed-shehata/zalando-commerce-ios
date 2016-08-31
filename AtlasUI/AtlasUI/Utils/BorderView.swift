//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class BorderView: UIView {

    var topBorder: Bool = false
    var rightBorder: Bool = false
    var bottomBorder: Bool = false
    var leftBorder: Bool = false
    var borderColor: UIColor = .blackColor()

    private let onePixel = 1 / UIScreen.mainScreen().scale

    override func layoutSubviews() {
        super.layoutSubviews()

        removeAllSubviews()

        if topBorder {
            addView(CGRect(x: 0, y: 0, width: bounds.width, height: onePixel))
        }
        if rightBorder {
            addView(CGRect(x: bounds.width - onePixel, y: 0, width: onePixel, height: bounds.height))
        }
        if bottomBorder {
            addView(CGRect(x: 0, y: bounds.height - onePixel, width: bounds.width, height: onePixel))
        }
        if leftBorder {
            addView(CGRect(x: 0, y: 0, width: onePixel, height: bounds.height))
        }
    }

    private func addView(frame: CGRect) {
        let view = UIView(frame: frame)
        view.backgroundColor = borderColor
        addSubview(view)
    }

}
