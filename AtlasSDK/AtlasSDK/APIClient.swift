//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIClient {

    let config: Config

    var urlSession: NSURLSession = NSURLSession.sharedSession()

    private let requestBuilders: APIRequestBuildersContainer

    init(config: Config) {
        self.config = config
        self.requestBuilders = APIRequestBuildersContainer(config: config)
    }

    func touch(endpoint: Endpoint, successStatus: HTTPStatus = .NoContent, completion: AtlasResult<Bool> -> Void) {
        touch(endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint, completion: AtlasResult<Bool> -> Void, successCompletion: JSONResponse -> Bool) {
        fetch(from: endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<Model> -> Void) {
        fetch(from: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<[Model]> -> Void) {
        fetch(from: endpoint, completion: completion) { response in
            guard let json = response.body, jsons = json.array.flatMap({ $0 }) else { return nil }
            return jsons.flatMap { Model(json: $0) }
        }
    }

    private func fetch<T>(from endpoint: Endpoint, completion: AtlasResult<T> -> Void, successHandler: JSONResponse -> T?) {
        self.requestBuilders.createBuilder(forEndpoint: endpoint, urlSession: urlSession).execute { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                if let parsedResponse = successHandler(response) {
                    completion(.success(parsedResponse))
                } else {
                    completion(.failure(AtlasAPIError.invalidResponseFormat))
                }
            }
        }

    }


}
