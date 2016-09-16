//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasAuthorizationToken = String
public typealias AtlasAuthorizationCompletion = AtlasResult<AtlasAuthorizationToken> -> Void

public protocol AtlasAuthorizationHandler {

    func authorizeTask(completion: AtlasAuthorizationCompletion) // TODO: Find more meaningful name

}

