//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {

    static var isSmallScreen: Bool {
        return main.bounds.height < 600
    }

}
