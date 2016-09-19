//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AtlasAuthorizationToken = String
public typealias AtlasAuthorizationCompletion = AtlasResult<AtlasAuthorizationToken> -> Void

public protocol AtlasAuthorizationHandler {

    func authorize(completion: AtlasAuthorizationCompletion)

}

public protocol AtlasAuthorizationProvider {

    func createHandler(completion: AtlasConfigCompletion)

}
