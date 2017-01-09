//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

protocol RowStackView {

    var titleLabel: UILabel { get }
    var arrowImageView: UIImageView { get }
    var showArrow: Bool { get set }

}

extension RowStackView {

    func setTitle(fromLocalizedKey localizerKey: String) {
        self.titleLabel.text = Localizer.format(string: localizerKey)
    }

    var showArrow: Bool {
        get {
            return arrowImageView.alpha == 1
        }
        set(show) {
            arrowImageView.alpha = show ? 1 : 0
        }
    }

}
