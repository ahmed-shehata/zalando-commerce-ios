//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI

class ZalandoCommerceUIViewController: UIViewController {

    fileprivate(set) static weak var presented: ZalandoCommerceUIViewController?

    let mainNavigationController: UINavigationController
    let uiInstance: ZalandoCommerceUI
    var dismissalReason: ZalandoCommerceUI.CheckoutResult?

    fileprivate var bottomConstraint: NSLayoutConstraint?
    fileprivate let loaderView = LoaderView()

    private let reachabilityNotifier = ReachabilityNotifier()
    private let completion: ZalandoCommerceUICheckoutCompletion

    fileprivate let screenshotCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    enum Error: LocalizableError {
        case dismissalReasonNotSet
    }

    init(forSKU sku: ConfigSKU, uiInstance: ZalandoCommerceUI, completion: @escaping ZalandoCommerceUICheckoutCompletion) {
        let getArticleDetailsViewController = GetArticleDetailsViewController(sku: sku)
        self.mainNavigationController = UINavigationController(rootViewController: getArticleDetailsViewController)
        self.completion = completion
        self.uiInstance = uiInstance

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

    func dismissCheckoutUI() throws {
        guard let reason = dismissalReason else { throw Error.dismissalReasonNotSet }
        let completion = self.completion
        dismiss(animated: true) {
            completion(reason)
        }
    }

}

extension ZalandoCommerceUIViewController {

    func showLoader(onView view: UIView? = nil) {
        let supportingView = view ?? UIApplication.topViewController()?.view
        loaderView.removeFromSuperview()
        supportingView?.addSubview(loaderView)
        loaderView.fillInSuperview()
        loaderView.buildView()
        loaderView.show()
    }

    func hideLoader() {
        loaderView.hide()
        loaderView.removeFromSuperview()
    }

    static func displayLoader(onView view: UIView? = nil, block: (@escaping () -> Void) -> Void) {
        presented?.showLoader(onView: view)
        block {
            presented?.hideLoader()
        }
    }

}

extension ZalandoCommerceUIViewController {

    static func push(_ viewController: UIViewController, animated: Bool = true) {
        ZalandoCommerceUIViewController.presented?.mainNavigationController.pushViewController(viewController, animated: animated)
    }

    fileprivate func configureStyle() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [ZalandoCommerceUIViewController.self]).tintColor = .orange
    }

}

extension ZalandoCommerceUIViewController {

    func storePresented() {
        ZalandoCommerceUIViewController.presented = self
    }

}

extension ZalandoCommerceUIViewController: UIScreenshotBuilder {

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
