//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

class Injector {

    enum InjectionError: Error {
        case typeNotRegistered
    }

    fileprivate var factories: [TypeKey: (Void) -> Any] = [:]

    func register<T>(_ factory: @escaping (Void) -> T) {
        let key = TypeKey(type: T.self)
        factories[key] = factory
    }

    func deregister<T>(_ type: T.Type) {
        let key = TypeKey(type: T.self)
        factories.removeValue(forKey: key)
    }

    func provide<T>() throws -> T {
        let key = TypeKey(type: T.self)
        guard let factory = factories[key]?() as? T else {
            throw InjectionError.typeNotRegistered
        }
        return factory
    }

    fileprivate struct TypeKey: Hashable, CustomDebugStringConvertible {
        let type: Any.Type

        var hashValue: Int {
            return "\(type)".hashValue
        }

        fileprivate var debugDescription: String {
            return "<\(type)>"
        }

    }

}

private func == (lhs: Injector.TypeKey, rhs: Injector.TypeKey) -> Bool {
    return lhs.type == rhs.type
}
