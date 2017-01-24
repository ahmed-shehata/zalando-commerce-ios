//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension JSON {

    enum SubscriptKey {
        case index(Int)
        case key(String)
    }

    subscript(try path: JSONSubscript...) -> JSON? {
        get {
            return self[path]
        }
    }

    subscript(path: JSONSubscript...) -> JSON {
        get {
            return self[path] ?? JSON.null
        }
    }

    subscript(path: [JSONSubscript]) -> JSON? {
        get {
            return path.reduce(self) { $0?[sub: $1] }
        }
    }

    fileprivate subscript(sub sub: JSONSubscript) -> JSON? {
        get {
            switch sub.jsonSubscript {
            case .index(let index):
                guard let array = self.arrayObject, index < array.count else { return nil }
                return JSON(array[index])
            case .key(let key):
                return JSON(self.dictionaryObject?[key])
            }
        }
    }

}

protocol JSONSubscript {

    var jsonSubscript: JSON.SubscriptKey { get }

}

extension Int: JSONSubscript {

    var jsonSubscript: JSON.SubscriptKey {
        return .index(self)
    }

}

extension String: JSONSubscript {

    var jsonSubscript: JSON.SubscriptKey {
        return .key(self)
    }

}
