//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol JSONRepresentable {

    func toJSON() -> JSONDictionary

}
