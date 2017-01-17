//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension JSON {

    var arrayObject: [Any]? {
        guard self.type == .array else { return nil }
        return self.rawArray
    }

    var array: [JSON] {
        guard self.type == .array else { return [] }
        return self.rawArray.flatMap { JSON($0) }
    }

    var dictionaryObject: [String: Any]? {
        guard type == .dictionary else { return nil }
        return self.rawDictionary
    }

    var dictionary: [String: JSON]? {
        guard type == .dictionary else { return nil }
        var newDictionary = [String: JSON](minimumCapacity: rawDictionary.count)
        for (key, value) in self.rawDictionary {
            newDictionary[key] = JSON(value)
        }
        return newDictionary
    }

    var string: String? {
        return type == .string ? rawString : nil
    }

    var number: NSNumber? {
        return type == .number ? rawNumber : nil
    }

    var bool: Bool? {
        return type == .bool ? rawBool : nil
    }

}

extension JSON {

    var url: URL? {
        return object()
    }

    var int: Int? {
        return object()
    }

    var float: Float? {
        return object()
    }

    var date: Date? {
        return object()
    }

    func object<T: JSONObjectifier>(try path: [JSONSubscript]? = nil) -> T? {
        let json: JSON?
        if let path = path {
            json = self[path]
        } else {
            json = self
        }
        return T(json: json)
    }

}

protocol JSONObjectifier {

    init?(json: JSON?)

}

extension URL: JSONObjectifier {

    init?(json: JSON?) {
        guard let string = json?.string else { return nil }
        self.init(string: string)
    }

}

extension Bool: JSONObjectifier {

    init?(json: JSON?) {
        guard let bool = json?.rawBool, json?.type == .bool else { return nil }
        self = bool
    }

}

extension Int: JSONObjectifier {

    init?(json: JSON?) {
        guard let number = json?.rawNumber, json?.type == .number else { return nil }
        self = number.intValue
    }

}

extension Float: JSONObjectifier {

    init?(json: JSON?) {
        guard let number = json?.rawNumber, json?.type == .number else { return nil }
        self = number.floatValue
    }

}

extension Date: JSONObjectifier {

    init?(json: JSON?) {
        let dateFormatter = RFC3339DateFormatter()

        guard let string = json?.string,
            let date = dateFormatter.date(from: string)
            else { return nil }
        self = date
    }

}
