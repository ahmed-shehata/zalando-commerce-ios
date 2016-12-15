//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct AtlasLogger {

    static var logger: Logger = PrintLogger()
    static var severity: AppLogSeverity = Debug.isEnabled ? .debug : .message {
        didSet {
            logger.severity = severity
        }
    }

}

extension AtlasLogger {

    public static func logMessage(_ items: Any..., verbose: Bool? = nil,
                                  function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        AtlasLogger.logger.log(as: .message, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func logDebug(_ items: Any..., verbose: Bool? = nil,
                                function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        AtlasLogger.logger.log(as: .debug, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func logError(_ items: Any..., verbose: Bool? = nil,
                                function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        AtlasLogger.logger.log(as: .error, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

}
