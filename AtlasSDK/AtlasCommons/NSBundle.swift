//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public extension NSBundle {

    public func pathsForResources(containingInName pattern: String? = nil) throws -> [String]? {
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
