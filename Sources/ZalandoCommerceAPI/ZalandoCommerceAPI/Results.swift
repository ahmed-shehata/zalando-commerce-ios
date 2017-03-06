//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

// TODO: document it, please...

public enum Result<T> {

    case success(T)
    case failure(Error)

}

public enum APIResult<T> {

    case success(T)
    case failure(Error, APIRequest<T>?)

}

public typealias ResultCompletion<T> = (Result<T>) -> Void

public typealias APIResultCompletion<T> = (APIResult<T>) -> Void
