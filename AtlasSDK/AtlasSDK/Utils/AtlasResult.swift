//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

public enum AtlasResult<T> {

    case success(T)
    case failure(Error)

}
