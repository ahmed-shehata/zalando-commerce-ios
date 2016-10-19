//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

public final class AtlasMockAPI {

    private static var isStarted = false
    public static let isEnabledFlag = "ATLAS_MOCK_API_ENABLED"

    private static let server = HttpServer()
    private static let serverURL = NSURL(string: "http://localhost:9080")! // swiftlint:disable:this force_unwrapping

    public static func startServer(wait timeout: NSTimeInterval = 15) throws {
        try server.registerEndpoints()
        try server.start(serverURL, forceIPv4: false, timeout: timeout)
        AtlasMockAPI.isStarted = true
        print("AtlasMockAPI server started @ \(serverURL)")
    }

    public static func stopServer(wait timeout: NSTimeInterval = 15) throws {
        try server.stop(timeout)
        print("AtlasMockAPI server stopped")
    }

    public static func endpointURL(forPath path: String, queryItems: [NSURLQueryItem] = []) -> NSURL {
        #if swift(>=2.3)
            let url = serverURL.URLByAppendingPathComponent(path)! // swiftlint:disable:this force_unwrapping
        #else
            let url = serverURL.URLByAppendingPathComponent(path)
        #endif
        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        return urlComponents?.URL ?? url
    }

    public static var hasMockedAPIStarted: Bool {
        return isStarted || NSProcessInfo.processInfo().arguments.contains(AtlasMockAPI.isEnabledFlag)
    }

}
