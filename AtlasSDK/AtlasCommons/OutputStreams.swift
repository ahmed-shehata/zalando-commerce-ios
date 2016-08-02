//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct StderrOutputStream: OutputStreamType {

    mutating func write(string: String) {
        fputs(string, stderr)
    }

}

struct StdoutOutputStream: OutputStreamType {

    mutating func write(string: String) {
        fputs(string, stdout)
    }

}

extension OutputStreamType {

    mutating func print(items: Any..., separator: String = " ", terminator: String = "\n") {
        let string = items.map { String($0) }.joinWithSeparator(separator)
        Swift.print(string, terminator: terminator, toStream: &self)
    }

}
