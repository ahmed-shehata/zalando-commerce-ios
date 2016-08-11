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

    func fetch<Model: JSONInitializable>(endpoint: EndpointType, completion: AtlasResult<Model> -> Void) {
        self.requestBuilders.createBuilder(forEndpoint: endpoint, urlSession: urlSession).execute { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                if let model = Model(json: response.body) {
                    completion(.success(model))
                } else {
                    completion(.failure(Error.invalidResponseFormat))
                }
            }
        }
    }

}
