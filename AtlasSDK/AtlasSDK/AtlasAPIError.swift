//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public struct AtlasAPIError: AtlasErrorType {

    public var code: Int { return apiErrorCode.rawValue }
    public let message: String
    public let extraDetails: String?

    public private(set) var apiErrorCode: AtlasAPIError.Code

    init(code: AtlasAPIError.Code, message: String = "") {
        self.apiErrorCode = code
        self.message = message
        self.extraDetails = nil
    }

}

extension AtlasAPIError: JSONInitializable {

    init(json: JSON) {
        if let code = json["status"].int, apiStatus = AtlasAPIError.Code(rawValue: code) {
            self.apiErrorCode = apiStatus
        } else {
            self.apiErrorCode = .Unknown
        }
        self.message = json["title"].string ?? "No <title> provided"
        self.extraDetails = json["detail"].string
    }

}

public extension AtlasAPIError {

    public enum Code: Int {

        case Unknown = -1
        case NoData = 1
        case Unauthorized = 401

    }

}
