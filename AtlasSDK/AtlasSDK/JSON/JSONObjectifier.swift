//
//  JSONObjectifier.swift
//  AtlasSDK
//
//  Created by Daniel Bauke on 17/01/2017.
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension JSON {

    var array: [JSON]? {
        guard self.type == .array else { return nil }
        return self.rawArray.flatMap { JSON($0) } // TODO: shouldn't be flatMap
    }

    var arrayValue: [JSON] {
        return array ?? []
    }

    var arrayObject: [Any] {
        return rawArray
    }

    var dictionary: [String: JSON]? {
        guard type == .dictionary else { return nil }
        var d = [String: JSON](minimumCapacity: rawDictionary.count)
        for (key, value) in rawDictionary {
            d[key] = JSON(value)
        }
        return d
    }

    var dictionaryValue: [String: JSON] {
        return self.dictionary ?? [:]
    }

    var dictionaryObject: [String: Any]? {
        guard type == .dictionary else { return nil }
        return self.rawDictionary
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

        guard let string = json?.rawString,
            let date = dateFormatter.date(from: string),
            json?.type == .string else { return nil }
        self = date
    }

}
