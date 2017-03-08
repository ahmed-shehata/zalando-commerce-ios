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

    func snap(toSuperview anchor: ViewAnchor, constant: CGFloat = 0) {
        guard let superview = superview else { return }
        _ = snap(toView: superview, anchor: anchor, constant: constant)
    }

    func snap(toView view: UIView, anchor: ViewAnchor, constant: CGFloat = 0) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = anchor.constraint(fromView: self, toView: view)
        constraint.constant = constant
        constraint.isActive = true
        return constraint
    }

    func snap(toTopViewController viewController: UIViewController) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor).isActive = true
    }

    func centerInSuperview() {
        centerHorizontallyInSuperview()
        centerVerticallyInSuperview()
    }

    func centerHorizontallyInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }

    func centerVerticallyInSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
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