//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension CGRect {

    var maximumCornerRadius: CGFloat {
        return min(width, height) / 2.0
    }
    
}
