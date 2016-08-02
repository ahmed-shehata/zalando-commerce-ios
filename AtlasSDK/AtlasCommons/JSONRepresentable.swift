//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol JSONRepresentable {

    func toJSON() -> [String: AnyObject]

}
