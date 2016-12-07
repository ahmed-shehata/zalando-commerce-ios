//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol JSONRepresentable {

    func toJSON() -> JSONDictionary

}
