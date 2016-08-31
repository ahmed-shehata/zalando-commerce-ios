//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIView {

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

}

extension UIView {

    func fillInSuperView() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraintEqualToAnchor(superview.topAnchor).active = true
        bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor).active = true
        rightAnchor.constraintEqualToAnchor(superview.rightAnchor).active = true
        leftAnchor.constraintEqualToAnchor(superview.leftAnchor).active = true
    }

    func setWidthAsSuperViewWidth(multiplier: CGFloat = 1) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToAnchor(superview.widthAnchor, multiplier: multiplier).active = true
    }

    func setSquareAspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 1).active = true
    }

    func setHeightToConstant(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraintEqualToConstant(height).active = true
    }

    func setWidthToConstant(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToConstant(width).active = true
    }

}
