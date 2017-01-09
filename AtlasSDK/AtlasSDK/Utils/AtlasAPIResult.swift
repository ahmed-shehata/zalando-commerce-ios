//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

public enum AtlasAPIResult<T> {

    case success(T)
    case failure(Error, APIRequest<T>?)

}
