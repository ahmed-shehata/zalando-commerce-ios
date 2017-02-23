//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

struct APIClient {

    let config: Config
    let urlSession: URLSession

    init(config: Config, session: URLSession = .shared) {
        self.config = config
        self.urlSession = session
    }

    func touch(endpoint: Endpoint,
               successStatus: HTTPStatus = .noContent,
               completion: @escaping APIResultCompletion<Bool>) {
        touch(endpoint: endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint,
               completion: @escaping APIResultCompletion<Bool>,
               successCompletion: @escaping (JSONResponse) -> Bool) {
        call(endpoint: endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint,
                                         completion: @escaping APIResultCompletion<Model>) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint,
                                         completion: @escaping APIResultCompletion<[Model]>) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return json.jsons.flatMap { Model(json: $0) }
        }
    }

    func redirect(endpoint: Endpoint,
                  completion: @escaping APIResultCompletion<URL>) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let urlString = response.httpHeaders?["Location"],
                let url = URL(string: urlString), HTTPStatus(statusCode: response.statusCode).isSuccessful
                else { return nil }
            return url
        }
    }

    fileprivate func call<T>(endpoint: Endpoint,
                             completion: @escaping APIResultCompletion<T>,
                             successHandler: @escaping (JSONResponse) -> T?) {
        let requestBuilder = RequestBuilder(forEndpoint: endpoint, urlSession: urlSession)
        var apiRequest = APIRequest(requestBuilder: requestBuilder, successHandler: successHandler)
        apiRequest.execute(append: completion)
    }

}
