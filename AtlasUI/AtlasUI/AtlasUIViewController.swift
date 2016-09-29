//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class AtlasUIViewController: UIViewController {

    let sizeSelectionNavigationController: UINavigationController

    init(atlasCheckout: AtlasCheckout, forProductSKU sku: String) {
        let sizeSelectionViewController = SizeSelectionViewController(checkout: atlasCheckout, sku: sku)
        sizeSelectionNavigationController = UINavigationController(rootViewController: sizeSelectionViewController)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        addChildViewController(sizeSelectionNavigationController)
        view.addSubview(sizeSelectionNavigationController.view)
        sizeSelectionNavigationController.view.fillInSuperView()
    }

}
