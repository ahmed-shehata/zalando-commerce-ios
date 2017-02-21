//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public protocol SKU: Equatable {
    static var pattern: String { get }

    var value: String { get }
    init(value: String)
    init?(string: String?)
}

public func == <T: SKU>(lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

public func == <T: SKU>(lhs: T, rhs: String) -> Bool {
    return lhs.value == rhs
}

extension SKU {

    public init?(string: String?) {
        guard let string = string, Self.isValid(string: string) else { return nil }
        self.init(value: string)
    }

    var isValid: Bool {
        return Self.isValid(string: value)
    }

    static func isValid(string: String?) -> Bool {
        guard let string = string else { return false }
        return string.range(of: "^\(Self.pattern)$",
            options: [.caseInsensitive, .regularExpression]) != nil
    }

    static var empty: Self {
        return Self(value: "")
    }

}

public struct ModelSKU: SKU {

    public let value: String
    public static let pattern = "[A-z0-9]{9}"

    public init(value: String) {
        self.value = value
    }

}

public struct ColorSKU: SKU {

    public let value: String
    public static let pattern = "\(ModelSKU.pattern)-[A-z0-9]{3}"

    public init(value: String) {
        self.value = value
    }

}

public struct VariantSKU: SKU {

    public let value: String
    public static let pattern = "\(ColorSKU.pattern)[A-z0-9]{7}"

    public init(value: String) {
        self.value = value
    }

}
