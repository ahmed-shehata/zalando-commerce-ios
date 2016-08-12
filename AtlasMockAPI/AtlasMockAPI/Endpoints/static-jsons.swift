//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Swifter

extension HttpServer {

    func registerAvailableJSONMocks() throws {
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

}
