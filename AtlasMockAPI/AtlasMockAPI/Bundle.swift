//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension Bundle {

    func pathsForResources(containingInName pattern: String? = nil) throws -> [String]? {
        guard let resourcesPath = self.resourcePath else { return nil }

        let allResources = try FileManager.default.contentsOfDirectory(atPath: resourcesPath)

        guard let pattern = pattern else {
            return allResources
        }

        let matchingNames = allResources.filter { $0.contains(pattern) }

        return matchingNames.flatMap {
            self.path(forResource: $0, ofType: "")
        }
    }

}
