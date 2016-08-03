//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol JSONRepresentable {

    func toJSON() -> [String: AnyObject]

}
