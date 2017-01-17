//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter
import Freddy

extension HttpServer {

    func addGuestOrder() {
        let path = "/guest-checkout/api/orders"

        self[path] = { request in
            let data = Data(bytes: &request.body, count: request.body.count)
            let json = try! JSON(data: data) // swiftlint:disable:this force_try
            if json["checkout_id"] == nil {
                let url = "https://payment-gateway.kohle-integration.zalan.do/payment-method-selection-session/TOKEN/selection"
                return HttpResponse.raw(204, "No Content", ["Location": url], nil)
            } else {
                // swiftlint:disable:next line_length
                let json = "{\"order_number\":\"10105083300694\",\"billing_address\":{\"gender\":\"MALE\",\"first_name\":\"John\",\"last_name\":\"Doe\",\"street\":\"Mollstr. 1\",\"zip\":\"10178\",\"city\":\"Berlin\",\"country_code\":\"DE\"},\"shipping_address\":{\"gender\":\"MALE\",\"first_name\":\"John\",\"last_name\":\"Doe\",\"street\":\"Mollstr. 1\",\"zip\":\"10178\",\"city\":\"Berlin\",\"country_code\":\"DE\"},\"gross_total\":{\"amount\":10.45,\"currency\":\"EUR\"},\"tax_total\":{\"amount\":2.34,\"currency\":\"EUR\"},\"created\":\"2016-11-29T14:14:25.126Z\"}"
                return .ok(.text(json))
            }
        }
    }

}
