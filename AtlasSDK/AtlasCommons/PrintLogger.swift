//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

private extension AppLogSeverity {

    func logMark() -> String {
        switch self {
        case .Debug: return "🕷"
        case .Message: return "✳️"
        case .Error: return "🆘"
        }
    }

}

final class PrintLogger: LoggerType {

    var verbose: Bool = false
    var severity: AppLogSeverity = isDebug() ? .Debug : .Message
    var outputStream: OutputStreamType = StdoutOutputStream()

    private let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df
    }()

    func log(severity: AppLogSeverity, verbose: Bool? = nil, function: String, filePath: String, fileLine: Int, _ items: [Any]) {
        guard severity >= self.severity else { return }
        let meta = formatMeta(verbose: verbose ?? self.verbose, function: function, filePath: filePath, fileLine: fileLine)
        outputStream.print(severity.logMark(), meta, formatMessage(items))
    }

    private func formatMeta(verbose verbose: Bool, function: String, filePath: String, fileLine: Int) -> String {
        guard verbose else {
            return ""
        }

        let filename = (filePath as NSString).pathComponents.last ?? "(unknown)"
        return "\(dateFormatter.stringFromDate(NSDate())) [\(filename):\(fileLine) - \(function)]"
    }

}
