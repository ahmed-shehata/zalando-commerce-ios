//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum ViewAnchor {
    case top
    case right
    case bottom
    case left

    fileprivate func constraint(fromView view1: UIView, toView view2: UIView) -> NSLayoutConstraint {
        switch self {
        case .top: return view1.topAnchor.constraint(equalTo: view2.topAnchor)
        case .right: return view1.rightAnchor.constraint(equalTo: view2.rightAnchor)
        case .bottom: return view1.bottomAnchor.constraint(equalTo: view2.bottomAnchor)
        case .left: return view1.leftAnchor.constraint(equalTo: view2.leftAnchor)
        }
    }

}

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

    func snap(toSuperview anchor: ViewAnchor, constant: CGFloat = 0) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = anchor.constraint(fromView: self, toView: superview)
        constraint.constant = constant
        constraint.isActive = true
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

    static func animate(duration: AnimationDuration = AnimationDuration.default, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration.rawValue, animations: animations)
    }

    static func animate(duration: AnimationDuration = AnimationDuration.default,
                        animations: @escaping () -> Void,
                        completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration.rawValue, animations: animations, completion: completion)
    }

}
