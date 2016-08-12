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
        addLoginEndpoint()
    }

    func start(url: NSURL, forceIPv4: Bool, timeout: NSTimeInterval) throws {
        let port = UInt16(url.port!.unsignedIntegerValue) // swiftlint:disable:this force_unwrapping
        try self.start(port, forceIPv4: forceIPv4)
        try wait(timeout, isRunning: true)
    }

    func stop(timeout: NSTimeInterval) throws {
        self.stop()
        try wait(timeout, isRunning: false)
    }

    private func wait(timeout: NSTimeInterval, isRunning: Bool) throws {
        var waiting = 0.0
        let waitStep = 0.1
        while self.running != isRunning && waiting < timeout {
            NSThread.sleepForTimeInterval(waitStep)
            waiting += waitStep
        }

        if self.running != isRunning {
            throw HttpServerError.TimeoutOnStop(timeout)
        }
    }

    func respond(forPath path: String, withText text: String) {
        self[path] = { _ in
            return .OK(.Text(text))
        }
    }

}
