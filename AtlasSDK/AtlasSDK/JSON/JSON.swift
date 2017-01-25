//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// Concept influenced by [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

import Foundation

struct JSON {

    enum Error: Swift.Error {
        case incorrectData
        case parseError(error: NSError)
    }

    static let null = JSON(NSNull())
    private static let numberType = String(describing: type(of: NSNumber(value: 1)))
    private static let decimalNumberType = String(describing: type(of: NSDecimalNumber(value: 1)))
    fileprivate static let dateFormatter = RFC3339DateFormatter()

    let isBool: Bool
    let rawObject: Any

    init(string: String,
         encoding: String.Encoding = .utf8,
         options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        guard let data = string.data(using: encoding) else { throw Error.incorrectData }
        try self.init(data: data, options: options)
    }

    init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        do {
            self.rawObject = try JSONSerialization.jsonObject(with: data, options: options)
            self.isBool = JSON.isBool(object: rawObject)
        } catch let e {
            AtlasLogger.logError(e)
            throw Error.parseError(error: e as NSError)
        }
    }

    init(_ object: Any?) {
        self.rawObject = object ?? JSON.null.rawObject
        self.isBool = JSON.isBool(object: rawObject)
    }

    private static func isBool(object: Any) -> Bool {
        let objectType = String(describing: type(of: object))
        return object is Bool && objectType != JSON.numberType && objectType != JSON.decimalNumberType
    }

}

extension JSON: CustomStringConvertible {

    var description: String {
        return String(describing: rawObject)
    }

}

extension JSON {

    var jsons: [JSON] {
        guard let array = self.array else { return [] }
        return array.map { JSON($0) }
    }

    var array: [Any]? {
        return self.rawObject as? [Any]
    }

    var dictionary: [String: Any]? {
        return self.rawObject as? [String: Any]
    }

    var string: String? {
        return self.rawObject as? String
    }

    var number: NSNumber? {
        guard !isBool else { return nil }
        return self.rawObject as? NSNumber
    }

    var bool: Bool? {
        guard isBool else { return nil }
        return self.rawObject as? Bool
    }

    var int: Int? {
        return number?.intValue
    }

    var float: Float? {
        return number?.floatValue
    }

    var double: Double? {
        return number?.doubleValue
    }

    var isNull: Bool {
        return self.rawObject is NSNull
    }

    var url: URL? {
        guard let string = self.string else { return nil }
        return URL(string: string)
    }

    var date: Date? {
        guard let string = self.string,
            let date = JSON.dateFormatter.date(from: string)
            else { return nil }

        return date
    }

}

extension JSON: Equatable { }

func == (lhs: JSON, rhs: JSON) -> Bool {
    if lhs.isNull && rhs.isNull {
        return true
    }
    if let lhs = lhs.bool, let rhs = rhs.bool, lhs == rhs {
        return true
    }
    if let lhs = lhs.number, let rhs = rhs.number, lhs == rhs {
        return true
    }
    if let lhs = lhs.string, let rhs = rhs.string, lhs == rhs {
        return true
    }

    if let larr = lhs.array, let rarr = rhs.array {
        return larr as NSArray == rarr as NSArray
    }
    if let ldict = lhs.dictionary, let rdict = rhs.dictionary {
        return ldict as NSDictionary == rdict as NSDictionary
    }

    return false
}
