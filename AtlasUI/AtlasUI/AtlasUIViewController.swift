//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class AtlasUIViewController: UIViewController {

    let mainNavigationController: UINavigationController

    init(atlasCheckout: AtlasCheckout, forProductSKU sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(checkout: atlasCheckout, sku: sku)
        mainNavigationController = UINavigationController(rootViewController: sizeSelectionViewController)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        addChildViewController(mainNavigationController)
        view.addSubview(mainNavigationController.view)
        mainNavigationController.view.fillInSuperView()
    }

}
