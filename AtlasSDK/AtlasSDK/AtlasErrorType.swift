//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public protocol ErrorStatusType {

    var code: IntegerLiteralType { get }

}

public protocol AtlasErrorType: ErrorType, ErrorStatusType, CustomStringConvertible {

    var message: String { get }
    var extraDetails: String? { get }

}

extension AtlasErrorType {

    public var description: String {
        let text = "\(self.dynamicType): \(message) (\(code))"
        if let extraDetails = extraDetails {
            return "\(text): \(extraDetails)"
        } else {
            return text
        }
    }

}
