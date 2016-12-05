//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct StderrOutputStream: TextOutputStream {

    mutating func write(_ string: String) {
        fputs(string, stderr)
    }

}

struct StdoutOutputStream: TextOutputStream {

    mutating func write(_ string: String) {
        fputs(string, stdout)
    }

}

extension TextOutputStream {

    mutating func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let string = items.map { String(describing: $0) }.joined(separator: separator)
        Swift.print(string, terminator: terminator, to: &self)
    }

}
