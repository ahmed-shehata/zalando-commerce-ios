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

    func start(url: NSURL, forceIPv4: Bool, timeout: NSTimeInterval) throws {
        let port = UInt16(url.port!.unsignedIntegerValue) // swiftlint:disable:this force_unwrapping
        try self.start(port, forceIPv4: forceIPv4)
        try wait(timeout, isRunning: true)
    }

    func stop(timeout: NSTimeInterval) throws {
        self.stop()
        try wait(timeout, isRunning: false)
    }

    func registerEndpoints() throws {
        addRootResponse()
        try addCustomerEndpoint()
        try registerAvailableJSONMocks()
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

    private func addRootResponse() {
        self.respond(forPath: "/", withText: "AtlasMockAPI server ready")
    }

    private func addCustomerEndpoint() throws {
        let path = "/customer"
        guard let authorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-auth.json")?.first,
            unauthorizedFilePath = try serverBundle.pathsForResources(containingInName: "!customer-not-auth.json")?.first
        else { return }

        let authorizedContent = try String(contentsOfFile: authorizedFilePath)

        self[path] = { request in
            let isAuthorized = request.headers["authorization"]?.containsString("Bearer ") ?? false
            if isAuthorized {
                return .OK(.Text(authorizedContent))
            } else {
                return HttpResponse.RAW(401, "Unauthorized", nil) { writer in
                    let unauthorizedFile = try File.openForReading(unauthorizedFilePath)
                    try writer.write(unauthorizedFile)
                }
            }
        }
        print("Registered endpoint: GET", path)
    }

    private func registerAvailableJSONMocks() throws {
        let jsonExt = ".json"

        guard let jsonFiles = try serverBundle.pathsForResources(containingInName: jsonExt) else { return }

        for filePath in jsonFiles {
            guard let fullFilePath = NSURL(fileURLWithPath: filePath).lastPathComponent?
                .stringByReplacingOccurrencesOfString(jsonExt, withString: "")
                .replace("|", "/")
            where !fullFilePath.containsString("!")
            else { continue }

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
