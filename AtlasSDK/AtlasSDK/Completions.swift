//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public enum AtlasResult<T> {

    case success(T)
    case failure(Error)

}

public typealias ResultCompletion<T> = (AtlasResult<T>) -> Void

// -------------------------

public enum AtlasAPIResult<T> {

    case success(T)
    case failure(Error, APIRequest<T>?)

}

public typealias APIResultCompletion<T> = (AtlasAPIResult<T>) -> Void
