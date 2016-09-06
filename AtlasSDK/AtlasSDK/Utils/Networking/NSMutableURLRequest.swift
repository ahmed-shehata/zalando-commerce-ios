//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {

    func curlCommandRepresentation() -> String {
        var curlComponents = ["curl -i"]

        guard let URL = self.URL else { return "curl command could not be created" }

        curlComponents.append("-X \(self.HTTPMethod)")

        self.allHTTPHeaderFields?.forEach {
            curlComponents.append("-H \"\($0): \($1)\"")
        }

        if let HTTPBodyData = self.HTTPBody,
            HTTPBody = String(data: HTTPBodyData, encoding: NSUTF8StringEncoding) {
                var escapedBody = HTTPBody.stringByReplacingOccurrencesOfString("\\\"", withString: "\\\\\"")
                escapedBody = escapedBody.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")

                curlComponents.append("-d \"\(escapedBody)\"")
        }

        curlComponents.append("\"\(URL.absoluteString)\"")

        return curlComponents.joinWithSeparator(" \\\n\t")
    }

    func debugLog() -> NSMutableURLRequest {
        AtlasLogger.logDebug(curlCommandRepresentation())
        return self
    }

    func authorize(withToken token: String?) -> NSMutableURLRequest {
        if let token = token {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return self
    }

    convenience init(endpoint: Endpoint) throws {
        self.init(URL: endpoint.URL)
        self.HTTPMethod = endpoint.method.rawValue
        self.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
        let acceptTypes = [endpoint.acceptedContentType, "application/x.problem+json"].flatMap { $0 }
        self.setValue(acceptTypes.joinWithSeparator(","), forHTTPHeaderField: "Accept")
        self.HTTPBody = try NSData(json: endpoint.parameters)
    }

}
