//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIScreen {

    static var isSmallScreen: Bool {
        return mainScreen().bounds.height < 600
    }

}
