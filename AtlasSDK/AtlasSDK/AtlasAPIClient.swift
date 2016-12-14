//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

public struct AtlasAPIClient {

    public let config: Config

    public var salesChannelCountry: String {
        return config.salesChannel.countryCode
    }

    public var salesChannelLanguage: String {
        return config.salesChannel.languageCode
    }

    var urlSession: URLSession = URLSession.shared

    init(config: Config) {
        self.config = config
    }

    func touch(endpoint: Endpoint, successStatus: HTTPStatus = .noContent, completion: @escaping (AtlasAPIResult<Bool>) -> Void) {
        touch(endpoint: endpoint, completion: completion) { response in
            return response.statusCode == successStatus
        }
    }

    func touch(endpoint: Endpoint,
               completion: @escaping (AtlasAPIResult<Bool>) -> Void,
               successCompletion: @escaping (JSONResponse) -> Bool) {
        call(endpoint: endpoint, completion: completion) { response in
            return successCompletion(response)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: @escaping (AtlasAPIResult<Model>) -> Void) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body else { return nil }
            return Model(json: json)
        }
    }

    func fetch<Model: JSONInitializable>(from endpoint: Endpoint, completion: @escaping (AtlasAPIResult<[Model]>) -> Void) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let json = response.body, let jsons = json.array.flatMap({ $0 }) else { return nil }
            return jsons.flatMap { Model(json: $0) }
        }
    }

    func fetchRedirectLocation(endpoint: Endpoint, completion: @escaping (AtlasAPIResult<URL>) -> Void) {
        call(endpoint: endpoint, completion: completion) { response in
            guard let urlString = response.httpHeaders?["Location"],
                let url = URL(string: urlString), HTTPStatus(statusCode: response.statusCode).isSuccessful
                else { return nil }
            return url
        }
    }

    fileprivate func call<T>(endpoint: Endpoint,
                             completion: @escaping (AtlasAPIResult<T>) -> Void,
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
        let authNotification: NSNotification.Name = isAuthorized ? .AtlasAuthorized : .AtlasDeauthorized
        var userInfo: [AnyHashable: Any]? = nil
        if let token = token {
            userInfo = [Options.InfoKey.useSandboxEnvironment: token.useSandboxEnvironment,
                Options.InfoKey.clientId: token.clientId]
        }

        NotificationCenter.default.post(name: authNotification, object: self, userInfo: userInfo)
        NotificationCenter.default.post(name: .AtlasAuthorizationChanged, object: self, userInfo: userInfo)
    }

}
