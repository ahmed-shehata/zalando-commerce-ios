//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

enum HttpServerError: Error {
    case timeoutOnStart(TimeInterval)
    case timeoutOnStop(TimeInterval)
}

extension HttpServer {

    var serverBundle: Bundle { return Bundle(for: AtlasMockAPI.self) }

    func registerEndpoints() throws {
        addRootResponse()
        try addCustomerEndpoint()
        try registerAvailableJSONMocks()
        addAuthorizeEndpoint()
        addRedirectEndpoint()
    }

    func start(at url: URL, forceIPv4: Bool, timeout: TimeInterval) throws {
        let port = UInt16(url.port!) // swiftlint:disable:this force_unwrapping
        try self.start(port, forceIPv4: forceIPv4)
        try wait(seconds: timeout, forState: .running)
    }

    func stop(withGraceTimeout timeout: TimeInterval) throws {
        self.stop()
        try wait(seconds: timeout, forState: .stopped)
    }

    fileprivate func wait(seconds timeout: TimeInterval, forState state: HttpServerIOState) throws {
        let waitStep = 0.5
        var waiting = 0.0
        repeat {
            Thread.sleep(forTimeInterval: waitStep)
            waiting += waitStep
        } while self.state != state && waiting < timeout

        if self.state != state {
            throw HttpServerError.timeoutOnStop(timeout)
        }
    }

    func respond(forPath path: String, withText text: String) {
        self[path] = { _ in
            return .ok(.text(text))
        }
    }

}
