//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

// TODO: document it, please...

public enum AtlasResult<T> {

    case success(T)
    case failure(Error)

}
