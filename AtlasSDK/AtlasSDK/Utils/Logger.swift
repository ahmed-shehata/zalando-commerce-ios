//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum AppLogSeverity: Int {

    case debug, message, error

}

func >= (lhs: AppLogSeverity, rhs: AppLogSeverity) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}

protocol Logger {

    var verbose: Bool { get }
    var severity: AppLogSeverity { get set }
    var outputStream: TextOutputStream { get set }

    // swiftlint:disable:next function_parameter_count
    func log(as severity: AppLogSeverity, verbose: Bool?, function: String, filePath: String, fileLine: Int, _ items: [Any])

}

extension Logger {

    func formatMessage(_ items: [Any], verbose: Bool = false) -> String {
        return items.map { "\($0)" }.joined(separator: " ")
    }

}
