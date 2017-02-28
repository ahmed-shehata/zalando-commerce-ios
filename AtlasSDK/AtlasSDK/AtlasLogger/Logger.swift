//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public struct Logger {

    static var output: LoggerOutput = LoggerPrintOutput()
    static var severity: AppLogSeverity = Debug.isEnabled ? .debug : .message {
        didSet {
            output.severity = severity
        }
    }

}

extension Logger {

    public static func message(_ items: Any..., verbose: Bool? = nil,
                               function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .message, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func debug(_ items: Any..., verbose: Bool? = nil,
                             function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .debug, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func error(_ items: Any..., verbose: Bool? = nil,
                             function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        Logger.output.log(as: .error, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

}
