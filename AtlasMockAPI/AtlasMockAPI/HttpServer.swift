//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

enum HttpServerError: ErrorType {
    case TimeoutOnStart(NSTimeInterval)
    case TimeoutOnStop(NSTimeInterval)
}

extension HttpServer {

    var serverBundle: NSBundle { return NSBundle(forClass: AtlasMockAPI.self) }

    func registerEndpoints() throws {
        addRootResponse()
        try addCustomerEndpoint()
        try registerAvailableJSONMocks()
        addAuthorizeEndpoint()
        addRedirectEndpoint()
    }

    func start(url: NSURL, forceIPv4: Bool, timeout: NSTimeInterval) throws {
        let port = UInt16(url.port!.unsignedIntegerValue) // swiftlint:disable:this force_unwrapping
        try self.start(port, forceIPv4: forceIPv4)
        try wait(seconds: timeout, forState: .Running)
    }

    func stop(timeout: NSTimeInterval) throws {
        self.stop()
        try wait(seconds: timeout, forState: .Stopped)
    }

    private func wait(seconds timeout: NSTimeInterval, forState state: HttpServerIOState) throws {
        let waitStep = 0.5
        var waiting = 0.0
        repeat {
            NSThread.sleepForTimeInterval(waitStep)
            waiting += waitStep
        } while self.state != state && waiting < timeout

        if self.state != state {
            throw HttpServerError.TimeoutOnStop(timeout)
        }
    }

    func respond(forPath path: String, withText text: String) {
        self[path] = { _ in
            return .OK(.Text(text))
        }
    }

}
