//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init?(named imageName: String, bundledWith anyClass: AnyClass,
        compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) {
            let bundle = NSBundle(forClass: anyClass)
            self.init(named: imageName, inBundle: bundle, compatibleWithTraitCollection: traitCollection)
    }

}
