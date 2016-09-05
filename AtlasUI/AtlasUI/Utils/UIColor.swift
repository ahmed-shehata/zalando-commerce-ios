//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xff) / 255.0
        let green = CGFloat((hex >> 8) & 0xff) / 255.0
        let blue = CGFloat(hex & 0xff) / 255.0
        self.init(red: red, green:green, blue:blue, alpha: alpha)
    }

}
