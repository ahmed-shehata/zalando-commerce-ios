//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public protocol SKU: Equatable {

    static var pattern: SKUPattern { get }
    var value: String { get }

    init(value: String)
    init<T: SKU>(from sku: T) throws

}

public func == <T: SKU>(lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

enum SKUError: Swift.Error {
    case invalidPattern
    case invalidConversion
    case noValue
}

public enum SKUPattern: String {

    case model = "[A-z0-9]{9}"
    case config = "[A-z0-9]{9}-[A-z0-9]{3}"
    case simple = "[A-z0-9]{9}-[A-z0-9]{3}[A-z0-9]{7}"

    func isValid(string: String) -> Bool {
        return string.range(of: "^\(self.rawValue)$", options: [.regularExpression]) != nil
    }

    func find(in string: String) -> String? {
        guard let range = string.range(of: "^\(self.rawValue)", options: [.regularExpression])
            else { return nil }
        return string[range]
    }

}

extension SKU {

    var isValid: Bool {
        return Self.pattern.isValid(string: value)
    }

    init(validate string: String?) throws {
        guard let value = string else { throw SKUError.noValue }
        guard Self.pattern.isValid(string: value) else { throw SKUError.invalidPattern }
        self.init(value: value)
    }

    public init<T: SKU>(from sku: T) throws {
        guard let newValue = Self.pattern.find(in: sku.value)
            else { throw SKUError.invalidConversion }
        self.init(value: newValue)
    }

    static var empty: Self {
        return Self(value: "")
    }

}

public struct ModelSKU: SKU {

    public let value: String
    public static let pattern: SKUPattern = .model

    public init(value: String) {
        self.value = value
    }

}

public struct ConfigSKU: SKU {

    public let value: String
    public static let pattern: SKUPattern = .config

    public init(value: String) {
        self.value = value
    }

}

public struct SimpleSKU: SKU {

    public let value: String
    public static let pattern: SKUPattern = .simple

    public init(value: String) {
        self.value = value
    }

}
