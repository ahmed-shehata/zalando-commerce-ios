//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addAddresses() {
        let path = "/addresses"

        self[path] = { request in
            if let authorization = request.headers["authorization"], authorization == "Bearer TestTokenWithoutAddresses" {
                return .ok(.text("[]"))
            } else {
                // swiftlint:disable:next force_unwrapping
                let filePath = Bundle(for: AtlasMockAPI.self).path(forResource: "!addresses", ofType: "json")!
                let json = try! String(contentsOfFile: filePath) // swiftlint:disable:this force_try
                return .ok(.text(json))
            }
        }
    }

}
