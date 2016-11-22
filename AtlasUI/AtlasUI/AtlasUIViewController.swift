//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

public class AtlasUIViewController: UIViewController {

    let mainNavigationController: UINavigationController
    fileprivate let atlasReachability = AtlasReachability()

    static var shared: AtlasUIViewController? {
        return try? AtlasUI.provide()
    }

    fileprivate let loaderView: LoaderView = {
        let view = LoaderView()
        view.isHidden = true
        return view
    }()

    init(forSKU sku: String) {
        let sizeSelectionViewController = SizeListSelectionViewController(sku: sku)
        mainNavigationController = UINavigationController(rootViewController: sizeSelectionViewController)

        super.init(nibName: nil, bundle: nil)
    }

    required public  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        loadErrorView()
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.fillInSuperview()
        atlasReachability.setupReachability()
    }

    fileprivate func loadErrorView() {
        UserMessage.displayError(AtlasCheckoutError.unclassified)
        UserMessage.clearBannerError()
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

}
