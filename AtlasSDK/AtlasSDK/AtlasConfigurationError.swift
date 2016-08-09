//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public class AtlasConfigurationError: AtlasError {

    public enum ErrorCode: Int {
        case IncorrectConfigServiceResponse = -5
        case MissingClientId = -4
        case MissingSalesChannel = -3
        case MissingInterfaceLanguage = -2
        case Unknown = -1
    }

    init(code: ErrorCode, message: String? = nil) {
        super.init(code: code.rawValue, message: message ?? "\(code)")
    }

}
