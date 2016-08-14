//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func addCustomerEndpoint() throws {
        let path = "/customer"
        guard let authorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-auth.json")?.first,
            unauthorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-not-auth.json")?.first
        else { return }

        let authorizedContent = try String(contentsOfFile: authorizedFilePath)

        self[path] = { request in
            let isAuthorized = request.headers["authorization"]?.containsString("Bearer ") ?? false
            if isAuthorized {
                return .OK(.Text(authorizedContent))
            } else {
                return HttpResponse.RAW(401, "Unauthorized", nil) { writer in
                    let unauthorizedFile = try File.openForReading(unauthorizedFilePath)
                    try writer.write(unauthorizedFile)
                }
            }
        }
        print("Registered endpoint: GET", path)
    }

}
