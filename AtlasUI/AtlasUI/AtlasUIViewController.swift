//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasUIViewController: UIViewController {

    fileprivate(set) static weak var presented: AtlasUIViewController?

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        storePresented()

        configureStyle()
        UserError.loadBannerError()
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.snap(toSuperview: .top)
        mainNavigationController.view.snap(toSuperview: .right)
        bottomConstraint = mainNavigationController.view.snap(toView: view, anchor: .bottom)
        mainNavigationController.view.snap(toSuperview: .left)
        reachabilityNotifier.start()
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

    static func push(_ viewController: UIViewController, animated: Bool = true) {
        AtlasUIViewController.presented?.mainNavigationController.pushViewController(viewController, animated: animated)
    }

    fileprivate func configureStyle() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [AtlasUIViewController.self]).tintColor = .orange
    }

}

extension AtlasUIViewController {

    func storePresented() {
        AtlasUIViewController.presented = self
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
