//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct AtlasAPIClient {

    public let config: Config

    var urlSession: NSURLSession = NSURLSession.sharedSession()

    init(config: Config) {
        self.config = config
    }

    func touch(endpoint: Endpoint, successStatus: HTTPStatus = .NoContent, completion: AtlasAPIResult<Bool> -> Void) {
        touch(endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint, completion: AtlasAPIResult<Bool> -> Void, successCompletion: JSONResponse -> Bool) {
        call(endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasAPIResult<Model> -> Void) {
        call(endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasAPIResult<[Model]> -> Void) {
        call(endpoint, completion: completion) { response in
            guard let json = response.body, jsons = json.array.flatMap({ $0 }) else { return nil }
            return jsons.flatMap { Model(json: $0) }
        }
    }

    func fetchRedirectLocation(endpoint: Endpoint, successStatus: HTTPStatus = .NoContent, completion: AtlasAPIResult<NSURL> -> Void) {
        call(endpoint, completion: completion) { response in
            guard let
                urlString = response.httpHeaders?["Location"],
                url = NSURL(string: urlString) where response.statusCode == successStatus else { return nil }
            return url
        }
    }

    private func call<T>(endpoint: Endpoint, completion: AtlasAPIResult<T> -> Void, successHandler: JSONResponse -> T?) {
        let requestBuilder = RequestBuilder(forEndpoint: endpoint, urlSession: urlSession)
        var apiRequest = APIRequest(requestBuilder: requestBuilder, successHandler: successHandler)
        apiRequest.execute(completion)
    }

}
