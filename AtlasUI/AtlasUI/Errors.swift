//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

protocol UserPresentable: AtlasErrorType {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String

}

extension UserPresentable {

    func title(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString("\(self.dynamicType).title", formatArguments: formatArguments)
    }

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        return provider.localizer.localizedString(self.localizedDescriptionKey, formatArguments: formatArguments)
    }

}

extension AtlasAPIError: UserPresentable {

    func message(localizedWith provider: LocalizerProviderType, formatArguments: CVarArgType?...) -> String {
        switch self {
        case .nsURLError(let code, let details):
            return "\(details) (#\(code))"
        case .http(let status, let details):
            return "\(details~?) (#\(status~?))"
        case .backend(let status, _, let details):
            return "\(details~?) (#\(status~?))"
        default:
            return provider.localizer.localizedString(self.localizedDescriptionKey)
        }
    }

}

extension AtlasConfigurationError: UserPresentable { }

extension LoginError: UserPresentable { }
