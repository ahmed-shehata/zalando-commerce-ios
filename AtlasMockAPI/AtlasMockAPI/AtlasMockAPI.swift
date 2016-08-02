//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter
import AtlasCommons

public final class AtlasMockAPI {

    public static let isEnabledFlag = "ATLAS_MOCK_API_ENABLED"

    private static let server = HttpServer()
    private static let serverURL = NSURL(validUrl: "http://localhost:9080")

    public static func startServer(wait timeout: NSTimeInterval = 15) throws {
        server.addRootResponse()
        do {
            try server.registerAvailableJSONMocks()
            try server.start(serverURL, forceIPv4: false, timeout: timeout)

        } catch (let error) {
            print(error)
        }
        print("AtlasMockAPI server started")
    }

    public static func stopServer(wait timeout: NSTimeInterval = 15) throws {
        try server.stop(timeout)
        print("AtlasMockAPI server stopped")
    }

    public static func endpointURL(forPath path: String) -> NSURL {
        return serverURL.URLByAppendingPathComponent(path)
    }

}
