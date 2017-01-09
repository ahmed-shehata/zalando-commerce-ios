//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

public struct APIRequest<Model> {

    let requestBuilder: RequestBuilder
    let successHandler: (JSONResponse) -> Model?
    var completions: [(AtlasAPIResult<Model>) -> Void]

    init(requestBuilder: RequestBuilder, successHandler: @escaping (JSONResponse) -> Model?) {
        self.requestBuilder = requestBuilder
        self.successHandler = successHandler
        completions = []
    }

    public mutating func execute(_ completion: @escaping (AtlasAPIResult<Model>) -> Void) {
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
