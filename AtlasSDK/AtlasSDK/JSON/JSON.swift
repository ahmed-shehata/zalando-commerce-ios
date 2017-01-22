//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// Concept influenced by [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

import Foundation

struct JSON {

    static let null = JSON(NSNull())
    private static let decimalNumberType = String(describing: type(of: NSNumber(value: 1)))
    fileprivate static let dateFormatter = RFC3339DateFormatter()

    let isBool: Bool
    let rawObject: Any

    init?(string: String,
          encoding: String.Encoding = .utf8,
          options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        guard let data = string.data(using: encoding) else { return nil }
        try self.init(data: data, options: options)
    }

    init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        do {
            self.rawObject = try JSONSerialization.jsonObject(with: data, options: options)
            self.isBool = JSON.isBool(object: rawObject)
        } catch let e {
            AtlasLogger.logError(e)
            throw e
        }
    }

    init(_ object: Any?) {
        self.rawObject = object ?? JSON.null
        self.isBool = JSON.isBool(object: rawObject)
    }

    private static func isBool(object: Any) -> Bool {
        let objectType = String(describing: type(of: object))
        return object is Bool && objectType != JSON.decimalNumberType
    }

}

extension JSON: CustomStringConvertible {

    var description: String {
        return String(describing: rawObject)
    }

}

extension JSON {

    var arrayObject: [Any]? {
        return self.rawObject as? [Any]
    }

    var array: [JSON] {
        guard let array = self.arrayObject else { return [] }
        return array.flatMap { JSON($0) }
    }

    var dictionaryObject: [String: Any]? {
        return self.rawObject as? [String: Any]
    }

    var dictionary: [String: JSON] {
        guard let dictionary = self.dictionaryObject else { return [:] }
        var newDictionary = [String: JSON](minimumCapacity: dictionary.count)
        for (key, value) in dictionary {
            newDictionary[key] = JSON(value)
        }
        return newDictionary
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
