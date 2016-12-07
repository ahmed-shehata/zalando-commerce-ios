//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

/**
 Simple enum that reprensents the result of in completion block for every API call.
 */
public enum AtlasAPIResult<T> {

    case success(T)
    case failure(Error, APIRequest<T>?)

}
