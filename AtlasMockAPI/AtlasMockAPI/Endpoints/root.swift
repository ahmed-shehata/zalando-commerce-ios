//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addRootResponse() {
        self.respond(forPath: "/", withText: "AtlasMockAPI server ready")
    }

}
