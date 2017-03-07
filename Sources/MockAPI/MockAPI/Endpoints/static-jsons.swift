//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func registerAvailableJSONMocks() throws {
        let jsonExt = ".json"

        guard let jsonFiles = try serverBundle.pathsForResources(containingInName: jsonExt) else { return }

        for filePath in jsonFiles {
            let fullFilePath = URL(fileURLWithPath: filePath).lastPathComponent
                .replacingOccurrences(of: jsonExt, with: "")
                .replacingOccurrences(of: "|", with: "/")
            guard !fullFilePath.contains("!") else { continue }

            let pathComponents = fullFilePath.components(separatedBy: "*")
            let (method, urlPath) = (pathComponents[0], pathComponents[1])

            print("Registered endpoint:", method, urlPath)

            let contents = try String(contentsOfFile: filePath)
            switch method {
            case "POST":
                self.POST[urlPath] = { _ in
                    return .ok(.text(contents))
                }
            default:
                self[urlPath] = { _ in
                    return .ok(.text(contents))
                }
            }
        }
    }

}
