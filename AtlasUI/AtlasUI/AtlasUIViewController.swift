//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasUIViewController: UIViewController {

    static var presented: AtlasUIViewController?

    let mainNavigationController: UINavigationController
    let atlasUI: AtlasUI

    fileprivate var bottomConstraint: NSLayoutConstraint?
    fileprivate let loaderView = LoaderView()

    private let reachabilityNotifier = ReachabilityNotifier()

    fileprivate let screenshotCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    init(for sku: ConfigSKU, atlasUI: AtlasUI) {
        let getArticleDetailsViewController = GetArticleDetailsViewController(sku: sku)
        self.mainNavigationController = UINavigationController(rootViewController: getArticleDetailsViewController)
        self.atlasUI = atlasUI

        super.init(nibName: nil, bundle: nil)
        AtlasUIViewController.presented = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserError.loadBannerError()
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.snap(toSuperview: .top)
        mainNavigationController.view.snap(toSuperview: .right)
        bottomConstraint = mainNavigationController.view.snap(toView: view, anchor: .bottom)
        mainNavigationController.view.snap(toSuperview: .left)
        reachabilityNotifier.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanPresented()
    }

}

extension AtlasUIViewController {

    func showLoader() {
        loaderView.removeFromSuperview()
        UIApplication.topViewController()?.view.addSubview(loaderView)
        loaderView.fillInSuperview()
        loaderView.buildView()
        loaderView.show()
    }

    func hideLoader() {
        loaderView.hide()
        loaderView.removeFromSuperview()
    }

    static func displayLoader(block: (@escaping () -> Void) -> Void) {
        presented?.showLoader()
        block {
            presented?.hideLoader()
        }
    }

}

extension AtlasUIViewController {

    // TODO: use it instead of direct mainNavigationController.pushViewController
    static func push(_ viewController: UIViewController, animated: Bool = true) {
        AtlasUIViewController.presented?.mainNavigationController.pushViewController(viewController, animated: animated)
    }

}

extension AtlasUIViewController {

    fileprivate func cleanPresented() {
        guard parent == nil else { return }
        AtlasUIViewController.presented = nil
    }

}

extension AtlasUIViewController: UIScreenshotBuilder {

    func prepareForScreenshot() {
        showScreenshotCover()
        guard let checkoutSummaryVC = mainNavigationController.viewControllers.first as? CheckoutSummaryViewController else { return }
        bottomConstraint?.constant = checkoutSummaryVC.checkoutContainer.scrollViewDifference
    }

    func cleanupAfterScreenshot() {
        hideScreenshotCover()
        bottomConstraint?.constant = 0
    }

    private func showScreenshotCover() {
        screenshotCoverView.alpha = 1
        view.addSubview(screenshotCoverView)
        screenshotCoverView.fillInSuperview()
    }

    private func hideScreenshotCover() {
        UIView.animate(animations: { [weak self] in
            self?.screenshotCoverView.alpha = 0
        }, completion: { [weak self] _ in
            self?.screenshotCoverView.removeFromSuperview()
        })
    }

}
