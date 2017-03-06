//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension PickupPoint {

    var localizedTitle: String {
        switch kind {
        case .packstation: return Localizer.format(string: "addressListView.prefix.packstation") + ": " + id
        case .pickupPoint(let name): return name
        }
    }

    var localizedValue: String {
        guard let memberId = memberId else { return "" }
        return Localizer.format(string: "addressListView.prefix.memberID") + ": " + memberId
    }

}
