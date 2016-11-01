//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol RowStackView {

    var titleLabel: UILabel { get }
    var arrowImageView: UIImageView { get }
    var showArrow: Bool { get set }

}

extension RowStackView {

    internal func setTitle(localizerKey: String) {
        self.titleLabel.text = Localizer.string(localizerKey)
    }

    internal var showArrow: Bool {
        get {
            return arrowImageView.alpha == 1
        }
        set(show) {
            arrowImageView.alpha = show ? 1 : 0
        }
    }

}
