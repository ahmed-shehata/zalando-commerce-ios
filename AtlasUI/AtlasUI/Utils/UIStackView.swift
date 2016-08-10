//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIStackView {

    func addArrangedSubviewSideFilled(view: UIView) {
        addArrangedSubview(view: view, viewAnchor1: view.trailingAnchor, stackAnchor1: self.trailingAnchor,
            viewAnchor2: view.leadingAnchor, stackAnchor2: self.leadingAnchor)
    }

    func addArrangedSubview(view view: UIView, viewAnchor1: NSLayoutAnchor, stackAnchor1: NSLayoutAnchor,
        viewAnchor2: NSLayoutAnchor, stackAnchor2: NSLayoutAnchor) {
            self.addArrangedSubview(view)
            viewAnchor1.constraintEqualToAnchor(stackAnchor1).active = true
            viewAnchor2.constraintEqualToAnchor(stackAnchor2).active = true
    }

}
