//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

struct CheckoutSummaryViewModel {

    var dataModel: CheckoutSummaryDataModel {
        didSet {
            dataModel.validate(against: oldValue)
        }
    }
    var layout: CheckoutSummaryLayout

    init(dataModel: CheckoutSummaryDataModel, layout: CheckoutSummaryLayout) {
        self.dataModel = dataModel
        self.layout = layout
    }

}
