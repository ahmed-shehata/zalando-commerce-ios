//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

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

    static let onePixel = 1 / UIScreen.main.scale

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

    func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    static func waitForUIState(block: @escaping () -> Void) {
        Async.delay(delay: 0.1, block: block)
    }

    func configureSubviews<T>(subviewFoundHandler: (T) -> Void) {
        self.subviews.forEach { subview in
            if let neededSubview = subview as? T {
                subviewFoundHandler(neededSubview)
            } else {
                subview.configureSubviews(subviewFoundHandler: subviewFoundHandler)
            }
        }
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

    func centerInSuperview() {
        centerHorizontallyInSuperview()
        centerVerticallyInSuperview()
    }

    @discardableResult
    func snap(toSuperview anchor: ViewAnchor, constant: CGFloat = 0) -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        return snap(toView: superview, anchor: anchor, constant: constant)
    }

    @discardableResult
    func snap(toView view: UIView, anchor: ViewAnchor, constant: CGFloat = 0) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = anchor.constraint(fromView: self, toView: view)
        constraint.constant = constant
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func snap(toTopViewController viewController: UIViewController) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func centerHorizontallyInSuperview() -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func centerVerticallyInSuperview() -> NSLayoutConstraint? {
        guard let superview = superview else { return nil }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setSquareAspectRatio() -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1)
        constraint.isActive = true
        return constraint
    }

}

extension UIView {

    @discardableResult
    func setWidth(equalToView view: UIView?, multiplier: CGFloat = 1) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setWidth(equalToConstant width: CGFloat) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }

}

extension UIView {

    @discardableResult
    func setHeight(equalToView view: UIView?, multiplier: CGFloat = 1) -> NSLayoutConstraint? {
        guard let view = view else { return nil }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setHeight(equalToConstant height: CGFloat) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }

}

extension UIView {

    static func animate(duration: AnimationDuration = .default, animations: @escaping () -> Void) {
        guard duration != .noAnimation else {
            animations()
            return
        }
        UIView.animate(withDuration: duration.rawValue, animations: animations)
    }

    static func animate(duration: AnimationDuration = .default, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        guard duration != .noAnimation else {
            animations()
            completion(true)
            return
        }
        UIView.animate(withDuration: duration.rawValue, animations: animations, completion: completion)
    }

}
