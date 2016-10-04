//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum ViewAnchor {
    case top
    case right
    case bottom
    case left

    func anchorForView(view: UIView) -> NSLayoutAnchor {
        switch self {
        case .top: return view.topAnchor
        case .right: return view.rightAnchor
        case .bottom: return view.bottomAnchor
        case .left: return view.leftAnchor
        }
    }

}

extension UIView {

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func findFirstResponder() -> UIView? {
        guard !isFirstResponder() else { return self }
        for view in subviews {
            if let subView = view.findFirstResponder() {
                return subView
            }
        }
        return nil
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

    func snapAnchorToSuperView(anchor: ViewAnchor, constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constaint = anchor.anchorForView(self).constraintEqualToAnchor(anchor.anchorForView(superview))
        constaint.constant = constant
        constaint.active = true
    }

    func centerInSuperView() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor).active = true
        centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor).active = true
    }

    func setSquareAspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToAnchor(heightAnchor, multiplier: 1).active = true
    }

}

extension UIView {

    func setWidth(equalToView view: UIView?, multiplier: CGFloat = 1) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: multiplier).active = true
    }

    func setWidth(equalToConstant width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraintEqualToConstant(width).active = true
    }

}

extension UIView {

    func setHeight(equalToView view: UIView?, multiplier: CGFloat = 1) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: multiplier).active = true
    }

    func setHeight(equalToConstant height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraintEqualToConstant(height).active = true
    }

}
