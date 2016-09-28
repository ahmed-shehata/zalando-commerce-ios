//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIClient {

    public let config: Config

    internal var urlSession: NSURLSession = NSURLSession.sharedSession()

    init(config: Config) {
        self.config = config
    }

    func touch(endpoint: Endpoint, successStatus: HTTPStatus = .NoContent, completion: AtlasResult<Bool> -> Void) {
        touch(endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint, completion: AtlasResult<Bool> -> Void, successCompletion: JSONResponse -> Bool) {
        call(from: endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<Model> -> Void) {
        call(from: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<[Model]> -> Void) {
        call(from: endpoint, completion: completion) { response in
            guard let json = response.body, jsons = json.array.flatMap({ $0 }) else { return nil }
            return jsons.flatMap { Model(json: $0) }
        }
    }

    private func call<T>(from endpoint: Endpoint, completion: AtlasResult<T> -> Void, successHandler: JSONResponse -> T?) {
        var builder = RequestBuilder(forEndpoint: endpoint, urlSession: urlSession)
        builder.execute { result in
            switch result {
            case .failure(let error):
                AtlasLogger.logError("FAILED CALL", builder)

                dispatch_async(dispatch_get_main_queue()) {
                    completion(.failure(error))
                }
            case .success(let response):
                if let parsedResponse = successHandler(response) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.success(parsedResponse))
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.failure(AtlasAPIError.invalidResponseFormat))
                    }
                }
            }
        }
    }

}
