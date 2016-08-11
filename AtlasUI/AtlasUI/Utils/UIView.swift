//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIView {
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
