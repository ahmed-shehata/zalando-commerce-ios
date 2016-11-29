//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

private extension AppLogSeverity {

    func logMark() -> String {
        switch self {
        case .debug: return "🕷"
        case .message: return "✳️"
        case .error: return "🆘"
        }
    }

}

final class PrintLogger: Logger {

    var verbose: Bool = false
    var severity: AppLogSeverity = isDebug() ? .debug : .message
    var outputStream: TextOutputStream = StdoutOutputStream()

    fileprivate let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df
    }()

    func log(as severity: AppLogSeverity, verbose: Bool? = nil, function: String, filePath: String, fileLine: Int, _ items: [Any]) {
        guard severity >= self.severity else { return }
        let meta = formatMeta(verbose: verbose ?? self.verbose, function: function, filePath: filePath, fileLine: fileLine)
        outputStream.print(severity.logMark(), meta, formatMessage(items))
    }

    fileprivate func formatMeta(verbose: Bool, function: String, filePath: String, fileLine: Int) -> String {
        guard verbose else {
            return ""
        }

        let filename = (filePath as NSString).pathComponents.last ?? "(unknown)"
        return "\(dateFormatter.string(from: Date())) [\(filename):\(fileLine) - \(function)]"
    }

}
