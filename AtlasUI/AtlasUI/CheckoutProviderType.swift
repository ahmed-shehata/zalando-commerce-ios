//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol CheckoutProviderType: LocalizerProviderType {

    var checkout: AtlasCheckout! { get }

}

extension CheckoutProviderType {

    var localizer: Localizer {
        return checkout.localizer
    }

}
