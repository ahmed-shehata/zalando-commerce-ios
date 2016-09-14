//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct APIClient {

    public let config: Config

    var urlSession: NSURLSession = NSURLSession.sharedSession()

    private let requestBuilders: APIRequestBuildersContainer

    init(config: Config) {
        self.config = config
        self.requestBuilders = APIRequestBuildersContainer(config: config)
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<Model> -> Void) {
        fetch(from: endpoint, completion: completion) { successfulResponse in
            return Model(json: successfulResponse.body)
        }
    }


    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: AtlasResult<[Model]> -> Void) {
        fetch(from: endpoint, completion: completion) { successfulResponse in
            guard let jsons = successfulResponse.body.array.flatMap({ $0 }) else { return nil }
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
