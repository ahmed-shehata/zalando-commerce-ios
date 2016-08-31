//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIColor {

    convenience init(netHex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((netHex >> 16) & 0xff) / 255.0
        let green = CGFloat((netHex >> 8) & 0xff) / 255.0
        let blue = CGFloat(netHex & 0xff) / 255.0
        self.init(red: red, green:green, blue:blue, alpha: alpha)
    }

}
