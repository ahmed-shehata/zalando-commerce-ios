//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIRequest<T> {

    var requestBuilder: RequestBuilder
    let successHandler: JSONResponse -> T?
    let completion: AtlasAPIResult<T> -> Void

    public mutating func execute(secondCompletion: (AtlasAPIResult<T> -> Void)? = nil) {
        requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError("FAILED CALL", self.requestBuilder)
                dispatch_async(dispatch_get_main_queue()) {
                    switch error {
                    case AtlasAPIError.unauthorized:
                        self.finish(withResult: .abortion(error, self), forSecondCompletion: secondCompletion)

                    default:
                        self.finish(withResult: .failure(error), forSecondCompletion: secondCompletion)
                    }
                }

            case .success(let response):
                if let parsedResponse = self.successHandler(response) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.finish(withResult: .success(parsedResponse), forSecondCompletion: secondCompletion)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.finish(withResult: .failure(AtlasAPIError.invalidResponseFormat), forSecondCompletion: secondCompletion)
                    }
                }
            }
        }
    }

    private func finish(withResult result: AtlasAPIResult<T>, forSecondCompletion secondCompletion: (AtlasAPIResult<T> -> Void)? = nil) {
        secondCompletion?(result)
        completion(result)
    }

}
