//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIView {

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func findFirstResponder() -> UIView? {
        guard !isFirstResponder else { return self }
        for view in subviews {
            if let subView = view.findFirstResponder() {
                return subView
            }
        }
        return nil
    }

}

extension UIView {

    func fillInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
    }

    @nonobjc
    func snap(anchor: NSLayoutYAxisAnchor, toAnchor otherAnchor: NSLayoutYAxisAnchor?, constant: CGFloat = 0) {
        guard let otherAnchor = otherAnchor else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constaint = anchor.constraint(equalTo: otherAnchor)
        constaint.constant = constant
        constaint.isActive = true
    }

    @nonobjc
    func snap(anchor: NSLayoutXAxisAnchor, toAnchor otherAnchor: NSLayoutXAxisAnchor?, constant: CGFloat = 0) {
        guard let otherAnchor = otherAnchor else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constaint = anchor.constraint(equalTo: otherAnchor)
        constaint.constant = constant
        constaint.isActive = true
    }

    func centerInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }

    func setSquareAspectRatio() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
    }

}

extension UIView {

    func setWidth(equalToView view: UIView?, multiplier: CGFloat = 1) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }

    func setWidth(equalToConstant width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

}

extension UIView {

    func setHeight(equalToView view: UIView?, multiplier: CGFloat = 1) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }

    func setHeight(equalToConstant height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

}

extension UIView {

    static func animate(_ duration: AnimationDuration = AnimationDuration.default, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration.rawValue, animations: animations)
    }

    static func animate(_ duration: AnimationDuration = AnimationDuration.default,
                        animations: @escaping () -> Void,
                        completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration.rawValue, animations: animations, completion: completion)
    }

}
