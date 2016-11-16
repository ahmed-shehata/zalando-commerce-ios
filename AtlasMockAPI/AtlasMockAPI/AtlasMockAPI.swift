//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

public final class AtlasMockAPI {

    public static let isEnabledFlag = "ATLAS_MOCK_API_ENABLED"

    fileprivate static var isStarted = false
    fileprivate static let server = HttpServer()
    fileprivate static let serverURL = URL(string: "http://localhost:9080")! // swiftlint:disable:this force_unwrapping

    public static func startServer(wait timeout: TimeInterval = 15) throws {
        try server.registerEndpoints()
        try server.start(at: serverURL, forceIPv4: false, timeout: timeout)
        AtlasMockAPI.isStarted = true
        print("AtlasMockAPI server started @ \(serverURL)")
    }

    public static func stopServer(wait timeout: TimeInterval = 15) throws {
        try server.stop(withGraceTimeout: timeout)
        print("AtlasMockAPI server stopped")
    }

    public static func endpointURL(forPath path: String, queryItems: [URLQueryItem] = []) -> URL {
        let url = serverURL.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url ?? url
    }

    public static var hasMockedAPIStarted: Bool {
        return isStarted || ProcessInfo().arguments.contains(AtlasMockAPI.isEnabledFlag)
    }

}
