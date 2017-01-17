//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// Heavily influenced by [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

// TODO:
// - simplify arrayObject, array, arrayValue and dictionary as well
// - drop raw... and type and use internalObject directly with casting (could be problematic with bools)

import Foundation

struct JSON: CustomStringConvertible {

    enum DataType {
        case number, string, bool, array, dictionary, null
    }

    var description: String {
        return String(describing: internalObject)
    }

    static let null = JSON(NSNull())
    private static let decimalNumberType = String(describing: type(of: NSNumber(value: 1)))

    private(set) var type: DataType = .null
    private(set) var rawArray: [Any] = []
    private(set) var rawDictionary: [String: Any] = [:]
    private(set) var rawString: String = ""
    private(set) var rawNumber: NSNumber = 0
    private(set) var rawBool: Bool = false

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
                return JSON.null
            }
        }
        set {
            clearRawValues()
            switch newValue {
            case let number as NSNumber:
                let newValueType = String(describing: type(of: newValue))
                if newValueType == JSON.decimalNumberType {
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

    init?(string: String,
          encoding: String.Encoding = .utf8,
          options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        guard let data = string.data(using: encoding) else { return nil }
        try self.init(data: data, options: options)
    }

    init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        do {
            self.internalObject = try JSONSerialization.jsonObject(with: data, options: options)
        } catch let e {
            AtlasLogger.logError(e)
            throw e
        }
    }

    init(_ object: Any?) {
        self.internalObject = object ?? JSON.null
    }

    private mutating func clearRawValues() {
        rawArray = []
        rawDictionary = [:]
        rawString = ""
        rawNumber = 0
        rawBool = false
        type = .null
    }

}
