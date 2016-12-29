//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIRequest<T> {

    let requestBuilder: RequestBuilder
    let successHandler: (JSONResponse) -> T?
    var completions: [(AtlasAPIResult<T>) -> Void]

    init(requestBuilder: RequestBuilder, successHandler: @escaping (JSONResponse) -> T?) {
        self.requestBuilder = requestBuilder
        self.successHandler = successHandler
        completions = []
    }

    public mutating func execute(_ completion: @escaping (AtlasAPIResult<T>) -> Void) {
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
                        completions.forEach { $0(.failure(AtlasAPIError.invalidResponseFormat, self)) }
                    }
                }
            }
        }
    }

}
