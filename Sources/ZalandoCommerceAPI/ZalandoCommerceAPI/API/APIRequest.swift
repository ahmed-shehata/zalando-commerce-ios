//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

/**
 A bridge between API request call and a set of completions closures.

 Completions are run after the call is finished in the reversed order.

 - Note: Completions chain is used to provide authorization before a real call.
 */
public struct APIRequest<Model> {

    let requestBuilder: RequestBuilder
    let successHandler: (JSONResponse) -> Model?
    private var completions: [(APIResult<Model>) -> Void] = []

    init(requestBuilder: RequestBuilder, successHandler: @escaping (JSONResponse) -> Model?) {
        self.requestBuilder = requestBuilder
        self.successHandler = successHandler
    }

    /**
     Executes a request and eventually calls all completions closures in reversed order on
     a main thread.

     - Parameter completion: closure appended to a completions set (and in the result called
     as the first one when request finishes). Can return `AtlasResult.failure` with
     `APIError.invalidResponseFormat` if `successHandler` is not able to parse a response.
     */
    public mutating func execute(append completion: @escaping (APIResult<Model>) -> Void) {
        self.completions.append(completion)

        let completions = self.completions.reversed()
        let successHandler = self.successHandler

        requestBuilder.execute { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    completions.forEach { $0(.failure(error, self)) }
                }

            case .success(let response):
                if let parsedResponse = successHandler(response) {
                    DispatchQueue.main.async {
                        completions.forEach { $0(.success(parsedResponse)) }
                    }
                } else {
                    DispatchQueue.main.async {
                        completions.forEach { $0(.failure(APIError.invalidResponseFormat, self)) }
                    }
                }
            }
        }
    }

}
