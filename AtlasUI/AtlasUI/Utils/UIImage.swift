//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init?(named imageName: String, bundledWith anyClass: AnyClass,
                      compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) {
        let bundle = Bundle(for: anyClass)
        self.init(named: imageName, in: bundle, compatibleWith: traitCollection)
    }

}
