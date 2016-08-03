//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public final class AtlasLogger {

    static var logger: LoggerType = PrintLogger()
    static var severity: AppLogSeverity = isDebug() ? .Debug : .Message {
        didSet {
            logger.severity = severity
        }
    }

}

extension AtlasLogger {

    public static func logMessage(items: Any..., verbose: Bool? = nil,
        function: String = #function, filePath: String = #file, fileLine: Int = #line) {
            AtlasLogger.logger.log(.Message, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func logDebug(items: Any..., verbose: Bool? = nil,
        function: String = #function, filePath: String = #file, fileLine: Int = #line) {
            AtlasLogger.logger.log(.Debug, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

    public static func logError(items: Any..., verbose: Bool? = nil,
        function: String = #function, filePath: String = #file, fileLine: Int = #line) {
            AtlasLogger.logger.log(.Error, verbose: verbose, function: function, filePath: filePath, fileLine: fileLine, items)
    }

}
