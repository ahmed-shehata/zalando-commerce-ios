//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

extension URLRequest {

    func curlCommandRepresentation() -> String {
        var curlComponents = ["curl -i"]

        guard let url = self.url else { return "curl command could not be created" }

        curlComponents.append("-X \(self.httpMethod ~? "GET")")

        self.allHTTPHeaderFields?.forEach {
            curlComponents.append("-H \"\($0): \($1)\"")
        }

        if let HTTPBodyData = self.httpBody,
            let body = String(data: HTTPBodyData, encoding: String.Encoding.utf8) {
            var escapedBody = body.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            curlComponents.append("-d \"\(escapedBody)\"")
        }

        curlComponents.append("\"\(url.urlString)\"")

        return curlComponents.joined(separator: " \\\n\t")
    }

    func debugLog() -> URLRequest {
        if ProcessInfo.processInfo.arguments.contains("PRINT_REQUEST_DESCRIPTION") {
            AtlasLogger.logDebug(curlCommandRepresentation())
        }
        return self
    }

    @discardableResult
    mutating func authorize(withToken token: String?) -> URLRequest {
        if let token = token {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return self
    }

}
