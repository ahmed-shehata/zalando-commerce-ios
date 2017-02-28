//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

protocol LoggerOutput {

    var verbose: Bool { get }
    var severity: AppLogSeverity { get set }
    var outputStream: TextOutputStream { get set }

    // swiftlint:disable:next function_parameter_count
    func log(as severity: AppLogSeverity, verbose: Bool?, function: String, filePath: String, fileLine: Int, _ items: [Any])

}

private extension AppLogSeverity {

    func logMark() -> String {
        switch self {
        case .debug: return "🕷"
        case .message: return "✳️"
        case .error: return "🆘"
        }
    }

}

final class LoggerPrintOutput: LoggerOutput {

    var verbose: Bool = false
    var severity: AppLogSeverity = Debug.isEnabled ? .debug : .message
    var outputStream: TextOutputStream = StdoutOutputStream()

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df
    }()

    func log(as severity: AppLogSeverity, verbose: Bool? = nil, function: String, filePath: String, fileLine: Int, _ items: [Any]) {
        guard severity >= self.severity else { return }
        let meta = formatMeta(verbose: verbose ?? self.verbose, function: function, filePath: filePath, fileLine: fileLine)
        outputStream.print(severity.logMark(), meta, formatMessage(items))
    }

    private func formatMeta(verbose: Bool, function: String, filePath: String, fileLine: Int) -> String {
        guard verbose else {
            return ""
        }

        let filename = (filePath as NSString).pathComponents.last ?? "(unknown)"
        return "\(dateFormatter.string(from: Date())) [\(filename):\(fileLine) - \(function)]"
    }

    private func formatMessage(_ items: [Any], verbose: Bool = false) -> String {
        return items.map { "\($0)" }.joined(separator: " ")
    }

}
