//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter
import AtlasCommons

enum HttpServerError: ErrorType {
    case TimeoutOnStart(NSTimeInterval)
    case TimeoutOnStop(NSTimeInterval)
}

extension HttpServer {

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

    func addRootResponse() {
        self.respond(forPath: "/", withText: "AtlasMockAPI server ready")
    }

    func registerAvailableJSONMocks() throws {
        let serverBundle = NSBundle(forClass: AtlasMockAPI.self)
        let jsonExt = ".json"

        guard let jsonFiles = try serverBundle.pathsForResources(containingInName: jsonExt) else { return }

        for filePath in jsonFiles {
            guard let fullFilePath = NSURL(fileURLWithPath: filePath).lastPathComponent?
                .stringByReplacingOccurrencesOfString(jsonExt, withString: "")
                .replace("|", "/") else { continue }

            let contents = try String(contentsOfFile: filePath)
            let method = fullFilePath.componentsSeparatedByString("*")[0]
            let urlPath = fullFilePath.componentsSeparatedByString("*")[1]

            print("Registered endpoint:", method, urlPath)

            switch method {
            case "POST":
                self.POST[urlPath] = { _ in
                    return .OK(.Text(contents))
                }
            default:
                self[urlPath] = { _ in
                    return .OK(.Text(contents))
                }
            }
        }
    }

    func respond(forPath path: String, withText text: String) {
        self[path] = { _ in
            return .OK(.Text(text))
        }
    }

}

extension NSBundle {

    func pathsForResources(containingInName pattern: String? = nil) throws -> [String]? {
        guard let resourcesPath = self.resourcePath else { return nil }

        let allResources = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(resourcesPath)

        guard let pattern = pattern else {
            return allResources
        }

        let matchingNames = allResources.filter { $0.containsString(pattern) }

        return matchingNames.flatMap {
            self.pathForResource($0, ofType: "")
        }
    }

}
