//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public class AtlasError: AtlasErrorType {

    public static let ErrorDomain = "AtlasSDKDomain"

    public internal(set) var code: IntegerLiteralType
    public internal(set) var message: String
    public internal(set) var extraDetails: String?

    init(code: IntegerLiteralType, message: String, extraDetails: String? = nil) {
        self.code = code
        self.message = message
        self.extraDetails = extraDetails
    }

    convenience init(error: NSError) {
        self.init(code: error.code, message: error.localizedDescription)
    }

}
