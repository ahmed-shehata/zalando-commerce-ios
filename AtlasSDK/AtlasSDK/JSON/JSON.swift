//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

// TODO
// - dot notation to deeper paths: json["url.something"]
// - extensive tests
// - better naming for JSONObject
// - extension Date: JSONObject

import Foundation
import UIKit

import Foundation

struct JSON: CustomStringConvertible {

    enum DataType {
        case number, string, bool, array, dictionary, null
    }

    var description: String {
        return String(describing: internalObject)
    }

    private let decimalNumberType = "NSDecimalNumber"

    private(set) var type: DataType = .null
    private(set) var rawArray: [Any] = []
    private(set) var rawDictionary: [String: Any] = [:]
    private(set) var rawString: String = ""
    private(set) var rawNumber: NSNumber = 0
    private(set) var rawBool: Bool = false

    let rawNull = NSNull()

    fileprivate var internalObject: Any {
        get {
            switch self.type {
            case .array:
                return self.rawArray
            case .dictionary:
                return self.rawDictionary
            case .string:
                return self.rawString
            case .number:
                return self.rawNumber
            case .bool:
                return self.rawBool
            default:
                return self.rawNull
            }
        }
        set {
            clearRawValues()
            switch newValue {
            case let number as NSNumber:
                let newValueType = String(describing: type(of: newValue))
                if newValueType == decimalNumberType {
                    self.type = .number
                    self.rawNumber = number
                } else if let boolValue = newValue as? Bool {
                    self.type = .bool
                    self.rawBool = boolValue
                }
            case let bool as Bool:
                self.type = .bool
                self.rawBool = bool
            case let string as String:
                self.type = .string
                self.rawString = string
            case let array as [Any]:
                self.type = .array
                self.rawArray = array
            case let dictionary as [String: Any]:
                self.type = .dictionary
                self.rawDictionary = dictionary
            default:
                self.type = .null
            }
        }
    }

    init?(data: Data) throws {
        do {
            self.internalObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch let e {
            AtlasLogger.logError(e)
            throw e
        }
    }

    init?(_ object: Any?) {
        guard let object = object else { return nil }
        self.internalObject = object
    }

    private mutating func clearRawValues() {
        rawArray = []
        rawDictionary = [:]
        rawString = ""
        rawNumber = 0
        rawBool = false
    }

}

extension JSON {

    enum PathKey {
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
            return self[path]!
        }
    }

    subscript(path: [JSONSubscript]) -> JSON? {
        get {
            return path.reduce(self) { $0?[sub: $1] }
        }
    }

    fileprivate subscript(sub sub: JSONSubscript) -> JSON? {
        get {
            switch sub.jsonKey {
            case .index(let index):
                return JSON(self.rawArray[index])
            case .key(let key):
                return JSON(self.rawDictionary[key])
            }
        }
    }

}

protocol JSONSubscript {

    var jsonKey: JSON.PathKey { get }

}

extension Int: JSONSubscript {

    var jsonKey: JSON.PathKey {
        return .index(self)
    }

}

extension String: JSONSubscript {

    var jsonKey: JSON.PathKey {
        return .key(self)
    }

}
