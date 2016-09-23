//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public typealias AuthorizationToken = String
public typealias AuthorizationCompletion = AtlasResult<AuthorizationToken> -> Void

public protocol AuthorizationHandler {

    func authorize(completion: AuthorizationCompletion)

}
