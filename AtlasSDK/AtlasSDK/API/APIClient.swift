//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

typealias APIResultCompletion<Model> = (AtlasAPIResult<Model>) -> Void

struct APIClient {

    public let config: Config

    let urlSession: URLSession

    init(config: Config, session: URLSession = .shared) {
        self.config = config
        self.urlSession = session
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
            guard let json = response.body else { return nil }
            return json.jsons.flatMap { Model(json: $0) }
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

extension APIClient {

    /// Determines if client is authorized with access token to call restricted endpoints.
    public var isAuthorized: Bool {
        return config.authorizationToken != nil
    }

    /// Authorizes client with given access token required in restricted endpoints.
    ///
    /// - Postcondition:
    ///   - If a client is authorized successfully `NSNotification.Name.AtlasAuthorized`
    ///     is posted on `NotificationCenter.default`, otherwise it is `NSNotification.Name.AtlasDeauthorized`.
    ///   - `NSNotification.Name.AtlasAuthorizationChanged` is always posted regadless the result.
    ///
    /// - Parameter withToken: access token retrieved from OAuth
    ///
    /// - Returns: `true` if token was correctly stored and client is authorized, otherwise `false`
    @discardableResult
    public func authorize(withToken tokenValue: String) -> Bool {
        let token = APIAccessToken.store(token: tokenValue, for: config)
        let isAuthorized = token != nil
        notify(isAuthorized: isAuthorized, withToken: token)
        return isAuthorized
    }

    /// Deauthorizes a client from accessing restricted endpoints.
    public func deauthorize() {
        let token = APIAccessToken.delete(for: config)
        notify(isAuthorized: false, withToken: token)
    }

    /// Deauthorizes all clients by removing all stored tokens.
    public static func deauthorizeAll() {
        APIAccessToken.wipe().forEach { token in
            notify(client: nil, isAuthorized: false, withToken: token)
        }
    }

    private func notify(isAuthorized: Bool, withToken token: APIAccessToken?) {
        APIClient.notify(client: self, isAuthorized: isAuthorized, withToken: token)
    }

    private static func notify(client: APIClient?, isAuthorized: Bool, withToken token: APIAccessToken?) {
        let userInfo = token?.notificationUserInfo
        let authNotification: NSNotification.Name = isAuthorized ? .AtlasAuthorized : .AtlasDeauthorized

        NotificationCenter.default.post(name: authNotification, object: client, userInfo: userInfo)
        NotificationCenter.default.post(name: .AtlasAuthorizationChanged, object: client, userInfo: userInfo)
    }

}

extension APIAccessToken {

    var notificationUserInfo: [AnyHashable: Any] {
        return [
            Options.InfoKey.useSandboxEnvironment: self.useSandboxEnvironment,
            Options.InfoKey.clientId: self.clientId
        ]
    }
}
