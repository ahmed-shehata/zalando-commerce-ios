//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 Simple internal logger for the issues in AtlasSDK.

 Uses 3 basic logging levels:

 - `Logger.Severity.debug` (default when compiled with`$DEBUG`)
 - `Logger.Severity.message`
 - `Logger.Severity.error` (default in _Release_ mode)
 */
public struct Logger {

    enum Severity: Int {
        case debug, message, error
    }

    static var output: LoggerOutput = LoggerPrintOutput()
    static var severity: Severity = Debug.isEnabled ? .debug : .error {
        didSet {
            output.severity = severity
        }
    }

}

extension Logger {

    /**
     Logs a message constructed of `items` if logging level is `Logger.Severity.debug` only.

     - Parameters:
     - items: items to print out
     - verbose: flag to show details detailed information about function, file and line, where log was called
     - function: function name, where function was called (don't use it, relies on `#function`)
     - filePath: file name, where function was called (don't use it, relies on `#file`)
     - fileLine: file line number name, where function was called (don't use it, relies on `#line`)
     */
    public static func debug(_ items: Any..., verbose: Bool? = nil,
                             function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .debug, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    /**
     Logs a message constructed of `items` if logging level is `Logger.Severity.message` or `Logger.Severity.error`.

     - Parameters:
     - items: items to print out
     - verbose: flag to show details detailed information about function, file and line, where log was called
     - function: function name, where function was called (don't use it, relies on `#function`)
     - filePath: file name, where function was called (don't use it, relies on `#file`)
     - fileLine: file line number name, where function was called (don't use it, relies on `#line`)
     */
    public static func message(_ items: Any..., verbose: Bool? = nil,
                               function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .message, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    /**
     Logs a message constructed of `items` if logging level is `Logger.Severity.debug`,
     `Logger.Severity.message`, `Logger.Severity.error`.

     - Parameters:
     - items: items to print out
     - verbose: flag to show details detailed information about function, file and line, where log was called
     - function: function name, where function was called (don't use it, relies on `#function`)
     - filePath: file name, where function was called (don't use it, relies on `#file`)
     - fileLine: file line number name, where function was called (don't use it, relies on `#line`)
     */
    public static func error(_ items: Any..., verbose: Bool? = nil,
                             function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .error, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

}
