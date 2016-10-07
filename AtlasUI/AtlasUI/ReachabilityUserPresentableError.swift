//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct ReachabilityUserPresentableError: UserPresentable {

    func title(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.title")
    }

    func message(formatArguments: CVarArgType?...) -> String {
        return Localizer.string("Error.reachability.message")
    }

    func shouldDisplayGeneralMessage() -> Bool {
        return false
    }

}
