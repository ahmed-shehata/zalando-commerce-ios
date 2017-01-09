//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

class ActionTextField: UITextField {

    var canCopy: Bool = true
    var canPaste: Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return canCopy
        } else if action == #selector(paste(_:)) {
            return canPaste
        }

        return true
    }

}
