//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public class Injector {

    private static let sharedInstance = Injector()

    enum Error: ErrorType {
        case TypeNotRegistered
    }

    private var factories: [TypeKey: Void -> Any] = [:]

    func register<T>(factory: Void -> T) {
        let key = TypeKey(type: T.self)
        factories[key] = factory
    }

    func deregister<T>(type: T.Type) {
        let key = TypeKey(type: T.self)
        factories.removeValueForKey(key)
    }

    func provide<T>() throws -> T {
        let key = TypeKey(type: T.self)
        guard let factory = factories[key]?() as? T else {
            throw Error.TypeNotRegistered
        }
        return factory
    }

    private struct TypeKey: Hashable, CustomDebugStringConvertible {
        let type: Any.Type

        var hashValue: Int {
            return "\(type)".hashValue
        }

        private var debugDescription: String {
            return "<\(type)>"
        }

    }

}

private func == (lhs: Injector.TypeKey, rhs: Injector.TypeKey) -> Bool {
    return lhs.type == rhs.type
}

extension Injector {

    public static func register<T>(factory: Void -> T) {
        sharedInstance.register(factory)
    }

    public static func provide<T>() throws -> T {
        return try sharedInstance.provide()
    }

    public static func deregister<T>(type: T.Type) {
        sharedInstance.deregister(type)
    }

}
