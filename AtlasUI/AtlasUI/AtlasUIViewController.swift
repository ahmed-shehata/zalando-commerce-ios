//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class AtlasUIViewController: UIViewController {

    static var shared: AtlasUIViewController? {
        return try? AtlasUI.shared().provide()
    }

    let mainNavigationController: UINavigationController
    fileprivate let loaderView = LoaderView()
    private let atlasReachability = AtlasReachability()

    init(forSKU sku: String) {
        let getArticleDetailsViewController = GetArticleDetailsViewController(sku: sku)
        mainNavigationController = UINavigationController(rootViewController: getArticleDetailsViewController)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserError.loadBannerError()
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.fillInSuperview()
        atlasReachability.setupReachability()
    }

}

extension AtlasUIViewController {

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
        shared?.showLoader(onView: view)
        block {
            shared?.hideLoader()
        }
    }

}
