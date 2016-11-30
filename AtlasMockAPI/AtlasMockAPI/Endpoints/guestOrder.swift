//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter
import SwiftyJSON

extension HttpServer {

    func addGuestOrder() {
        let path = "/guest-checkout/api/orders"

        self[path] = { request in
            let data = NSData(bytes: &request.body, length: request.body.count)
            let json = JSON(data: data)
            if json["payment"] == nil {
                let url = "https://payment-gateway.kohle-integration.zalan.do/payment-method-selection-session/TOKEN/selection"
                return HttpResponse.RAW(204, "No Content", ["Location": url], nil)
            } else {
                return .MovedPermanently("http://localhost.charlesproxy.com:9080/guest-checkout/api/orders/withPaymentInRequest")
            }
        }
    }

}
