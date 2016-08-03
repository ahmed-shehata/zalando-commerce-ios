//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct Injector {

    enum Error: ErrorType {
        case NotFound
    }

    init() {}

    private var factories: [TypeKey: Void -> Any] = [:]

    mutating func register<T>(factory: Void -> T) {
        let key = TypeKey(type: T.self)
        factories[key] = factory
    }

    func provide<T>() throws -> T {
        let key = TypeKey(type: T.self)
        guard let factory = factories[key]?() as? T else {
            throw Error.NotFound
        }
        return factory
    }

    private struct TypeKey: Hashable {
        let type: Any.Type

        var hashValue: Int {
            return "\(type)".hashValue
        }
    }

}

private func == (lhs: Injector.TypeKey, rhs: Injector.TypeKey) -> Bool {
    return lhs.type == rhs.type
}
