//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

final class CheckoutPresentationController: UIPresentationController {

    private struct Constants {
        static let defaultHeightRatio: CGFloat = UIScreen.isSmallScreen ? 1.0 : 0.75
    }

    private let heightRatio: CGFloat

    private let effectView = UIVisualEffectView()

    private lazy var dimmingView: UIView? = {
        guard let containerView = self.containerView else { return nil }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        dimmingView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        return dimmingView
    }()

    init(presentedViewController: UIViewController, presentingViewController: UIViewController,
        heightRatio: CGFloat = Constants.defaultHeightRatio) {
            self.heightRatio = heightRatio
            effectView.frame = presentedViewController.view.frame
            presentedViewController.view.insertSubview(effectView, atIndex: 0)
            super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)

        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(dimmingViewTapped(_:))))
        containerView.insertSubview(dimmingView, atIndex: 0)

        let updateViews = {
            self.effectView.effect = UIBlurEffect(style: .ExtraLight)
            dimmingView.alpha = 1
        }

        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ _ in
                updateViews()
                }, completion: nil)
        } else {
            updateViews()
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let _ = containerView, _ = dimmingView else { return }
        let updateViews = {
            self.dimmingView?.alpha = 0
            self.effectView.effect = nil
        }

        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ _ in
                updateViews()
                }, completion: nil)
        } else {
            updateViews()
        }
    }

    override func frameOfPresentedViewInContainerView() -> CGRect {
        let rect = super.frameOfPresentedViewInContainerView()
        let newHeight = rect.height * heightRatio
        return CGRect(x: rect.origin.x,
            y: rect.origin.y + (rect.height - newHeight),
            width: rect.width,
            height: newHeight)
    }

    @objc private func dimmingViewTapped(sender: AnyObject?) {
        presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
