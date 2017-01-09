//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addCustomerEndpoint() throws {
        let path = "/customer"
        guard let authorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-auth.json")?.first,
            let unauthorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-not-auth.json")?.first
        else { return }

        let authorizedContent = try String(contentsOfFile: authorizedFilePath)

        self[path] = { request in
            let isAuthorized = request.headers["authorization"]?.contains("Bearer ") ?? false
            if isAuthorized {
                return .ok(.text(authorizedContent))
            } else {
                return HttpResponse.raw(401, "Unauthorized", nil) { writer in
                    let unauthorizedFile = try unauthorizedFilePath.openForReading()
                    try writer.write(unauthorizedFile)
                }
            }
        }
        print("Registered endpoint: GET", path)
    }

}
