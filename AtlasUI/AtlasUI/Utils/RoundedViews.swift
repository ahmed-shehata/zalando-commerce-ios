//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var isCircle: Bool = false
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clearColor()

    override func layoutSubviews() {
        super.layoutSubviews()

        if isCircle {
            layer.cornerRadius = bounds.maximumCornerRadius
        } else {
            layer.cornerRadius = min(bounds.maximumCornerRadius, cornerRadius)
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }

}

class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var isCircle: Bool = false
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clearColor()

    override func layoutSubviews() {
        super.layoutSubviews()

        if isCircle {
            layer.cornerRadius = bounds.maximumCornerRadius
        } else {
            layer.cornerRadius = min(bounds.maximumCornerRadius, cornerRadius)
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }

}

class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var isCircle: Bool = false
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clearColor()

    override func layoutSubviews() {
        super.layoutSubviews()

        if isCircle {
            layer.cornerRadius = bounds.maximumCornerRadius
        } else {
            layer.cornerRadius = min(bounds.maximumCornerRadius, cornerRadius)
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor
    }

}
