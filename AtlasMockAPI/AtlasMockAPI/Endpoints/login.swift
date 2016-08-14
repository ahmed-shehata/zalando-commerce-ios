//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addLoginEndpoint() {
        self.GET["/login"] = scopes {
            html {
                body {
                    form {
                        method = "POST"
                        action = "/login"

                        input { name = "email"; type = "email" }
                        input { name = "password"; type = "password" }

                        button {
                            type = "submit"
                            inner = "Login"
                        }
                    }
                }
            }
        }
    }

}
