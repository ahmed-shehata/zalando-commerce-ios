//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

public final class AtlasMockAPI {

    public static let isEnabledFlag = "ATLAS_MOCK_API_ENABLED"

    private static let server = HttpServer()
    private static let serverURL = NSURL(string: "http://localhost:9080")! // swiftlint:disable:this force_unwrapping

    public static func startServer(wait timeout: NSTimeInterval = 15) throws {
        server.addRootResponse()
        do {
            try server.registerAvailableJSONMocks()
            try server.start(serverURL, forceIPv4: false, timeout: timeout)
            print("AtlasMockAPI server started")
        } catch let error {
            print(error)
        }
    }

    public static func stopServer(wait timeout: NSTimeInterval = 15) throws {
        try server.stop(timeout)
        print("AtlasMockAPI server stopped")
    }

    public static func endpointURL(forPath path: String) -> NSURL {
        #if swift(>=2.3)
            return serverURL.URLByAppendingPathComponent(path)! // swiftlint:disable:this force_unwrapping
        #else
            return serverURL.URLByAppendingPathComponent(path)
        #endif
    }

}
