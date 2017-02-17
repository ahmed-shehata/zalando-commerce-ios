//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit

final class CheckoutPresentationController: UIPresentationController {

    fileprivate struct Constants {
        static let defaultHeightRatio: CGFloat = UIScreen.isSmallScreen ? 1.0 : 0.75
    }

    fileprivate let heightRatio: CGFloat

    fileprivate let effectView = UIVisualEffectView()

    fileprivate lazy var dimmingView: UIView? = {
        guard let containerView = self.containerView else { return nil }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.alpha = 0
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return dimmingView
    }()

    init(presentedViewController: UIViewController, presentingViewController: UIViewController?,
         heightRatio: CGFloat = Constants.defaultHeightRatio) {
        self.heightRatio = heightRatio
        effectView.frame = presentedViewController.view.frame
        presentedViewController.view.insertSubview(effectView, at: 0)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)

        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped)))
        containerView.insertSubview(dimmingView, at: 0)

        let updateViews = {
            self.effectView.effect = UIBlurEffect(style: .extraLight)
            dimmingView.alpha = 1
        }

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                updateViews()
            }, completion: nil)
        } else {
            updateViews()
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let _ = containerView, let _ = dimmingView else { return }
        let updateViews = {
            self.dimmingView?.alpha = 0
            self.effectView.effect = nil
        }

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                updateViews()
            }, completion: nil)
        } else {
            updateViews()
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let rect = super.frameOfPresentedViewInContainerView
        let newHeight = rect.height * heightRatio
        return CGRect(x: rect.origin.x,
                      y: rect.origin.y + (rect.height - newHeight),
                      width: rect.width,
                      height: newHeight)
    }

    @objc
    fileprivate func dimmingViewTapped() {
        if AtlasUIViewController.shared?.dismissalReason == nil {
            AtlasUIViewController.shared?.dismissalReason = AtlasUI.CheckoutResult.userCancelled
        }
        try? AtlasUIViewController.shared?.dismissAtlasCheckoutUI()
    }

}
