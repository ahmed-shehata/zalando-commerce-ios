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

    public static func endpointURL(forPath path: String) -> NSURL {
        return serverURL.URLByAppendingPathComponent(path)
    }

    public static var hasMockedAPIEnabled: Bool {
        return NSProcessInfo.processInfo().arguments.contains(AtlasMockAPI.isEnabledFlag) || AtlasMockAPI.isStarted
    }

}
