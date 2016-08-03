//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum AppLogSeverity: Int {

    case Debug, Message, Error

}

func >= (lhs: AppLogSeverity, rhs: AppLogSeverity) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}

protocol LoggerType {

    var verbose: Bool { get }
    var severity: AppLogSeverity { get set }
    var outputStream: OutputStreamType { get set }

    // swiftlint:disable:next function_parameter_count
    func log(severity: AppLogSeverity, verbose: Bool?, function: String, filePath: String, fileLine: Int, _ items: [Any])

}

extension LoggerType {

    func formatMessage(items: [Any], verbose: Bool = false) -> String {
        return items.map { "\($0)" }.joinWithSeparator(" ")
    }

}
