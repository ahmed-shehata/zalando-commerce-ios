//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIRequest<T> {

    var requestBuilder: RequestBuilder
    let successHandler: JSONResponse -> T?
    var completions: [AtlasAPIResult<T> -> Void]

    init(requestBuilder: RequestBuilder, successHandler: JSONResponse -> T?) {
        self.requestBuilder = requestBuilder
        self.successHandler = successHandler
        completions = []
    }

    public mutating func execute(completion: AtlasAPIResult<T> -> Void) {
        completions.append(completion)
        requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                dispatch_async(dispatch_get_main_queue()) {
                    self.completions.reverse().forEach { $0(.failure(error, self)) }
                }

            case .success(let response):
                if let parsedResponse = self.successHandler(response) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.completions.reverse().forEach { $0(.success(parsedResponse)) }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.completions.reverse().forEach { $0(.failure(AtlasAPIError.invalidResponseFormat, self)) }
                    }
                }
            }
        }
    }

}
