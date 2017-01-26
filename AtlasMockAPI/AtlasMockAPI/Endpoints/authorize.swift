//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addAuthorizeEndpoint() {
        let path = "/oauth2/authorize"

        self[path] = { req in
            scopes {
                html {
                    body {
                        form {
                            method = "POST"
                            action = path

                            div {
                                input { name = "username"; type = "email"; value = "foo@bar.baz"; idd = "username" }
                            }
                            div {
                                input { name = "password"; type = "password"; value = "qux-quux-corge"; idd = "password" }
                            }
                            req.queryParams.forEach { key, val in
                                input { name = key; type = "hidden"; value = val }
                            }

                            div {
                                input {
                                    type = "submit"
                                    value = "Login"
                                }
                            }
                        }
                    }
                }
            }(req)
        }

        self.POST[path] = { req in
            var params = [String: String]()
            req.parseUrlencodedForm().forEach { params[$0.0] = $0.1 }

            guard let redirectUri = params["redirect_uri"],
                params["username"] != nil,
                params["password"] != nil,
                params["realm"] != nil,
                params["response_type"] == "token",
                params["client_id"] != nil else {
                    let response = ["error": "invalid_grant",
                        "error_description": "The provided access grant is invalid, expired, or revoked."]
                    return HttpResponse.badRequest(.json(response as AnyObject))
            }

            return HttpResponse.movedPermanently("\(redirectUri)#access_token=TOKEN")
        }

    }
}
