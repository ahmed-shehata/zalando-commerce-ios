//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension AtlasErrorType {

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString(self.localizedDescriptionKey, formatArguments: formatArguments)
    }

}

extension AtlasAPIError {

    func message(localizedWith provider: LocalizerProviderType) -> String {
        let errorType = self as AtlasErrorType
        switch self {
        case .nsURLError(let code, let details):
            return errorType.message(localizedWith: provider, formatArguments: "\(details) (#\(code))")
        case .http(let status, let details):
            return errorType.message(localizedWith: provider, formatArguments: "\(details) (#\(status))")
        case .backend(_, let title, let details):
            return errorType.message(localizedWith: provider, formatArguments: title, details)
        default:
            return errorType.message(localizedWith: provider)
        }

    }

}
