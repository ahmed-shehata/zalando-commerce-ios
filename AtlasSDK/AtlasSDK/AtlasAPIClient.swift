//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

typealias APIResultCompletion<Model> = (AtlasAPIResult<Model>) -> Void

public struct AtlasAPIClient {

    public let config: Config

    var urlSession: URLSession = URLSession.shared

    init(config: Config) {
        self.config = config
    }

    func touch(endpoint: Endpoint, successStatus: HTTPStatus = .noContent, completion: @escaping SuccessCompletion) {
        touch(endpoint: endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint,
               completion: @escaping SuccessCompletion,
               successCompletion: @escaping (JSONResponse) -> Bool) {
        call(endpoint: endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: @escaping APIResultCompletion<Model>) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: @escaping APIResultCompletion<[Model]>) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body, let jsons = json.array.flatMap({ $0 }) else { return nil }
            return jsons.flatMap { Model(json: $0) }
        }
    }

    func fetchRedirectLocation(endpoint: Endpoint, completion: @escaping URLCompletion) {
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
        apiRequest.execute(completion)
    }

}

extension AtlasAPIClient {

    public var isAuthorized: Bool {
        return config.authorizationToken != nil
    }

    public func authorize(withToken tokenValue: String) {
        if let token = APIAccessToken.store(token: tokenValue, for: config) {
            AtlasAPIClient.notify(isAuthorized: true, withToken: token)
        } else {
            AtlasAPIClient.notify(isAuthorized: false, withToken: nil)
        }
    }

    public func deauthorize() {
        let token = APIAccessToken.delete(for: config)
        AtlasAPIClient.notify(isAuthorized: false, withToken: token)
    }

    public static func deauthorizeAll() {
        APIAccessToken.wipe().forEach { token in
            AtlasAPIClient.notify(isAuthorized: false, withToken: token)
        }
    }

    private static func notify(isAuthorized: Bool, withToken token: APIAccessToken?) {
        var userInfo: [AnyHashable: Any]?
        if let token = token {
            userInfo = [Options.InfoKey.useSandboxEnvironment: token.useSandboxEnvironment,
                        Options.InfoKey.clientId: token.clientId]
        }

        let authNotification: NSNotification.Name = isAuthorized ? .AtlasAuthorized : .AtlasDeauthorized
        NotificationCenter.default.post(name: authNotification, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: .AtlasAuthorizationChanged, object: nil, userInfo: userInfo)
    }

}
