//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

}
