//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol ConfigurableEndpoint: Endpoint {

    var serviceURL: URL { get }
    var path: String { get }
    var config: Config { get }

    var clientId: String { get }
    var salesChannel: String { get }

}

extension ConfigurableEndpoint {

    var clientId: String {
        return config.clientId
    }

    var salesChannel: String {
        return config.salesChannel.identifier
    }

    var headers: EndpointHeaders? {
        return ["X-Sales-Channel": salesChannel]
    }

    var url: URL {
        var urlComponents = URLComponents(validURL: serviceURL)
        urlComponents.queryItems = self.queryItems
        return urlComponents.validURL.appendingPathComponent(path)
    }

    var authorizationToken: String? { return config.authorizationToken }

}

protocol CatalogEndpoint: ConfigurableEndpoint { }

extension CatalogEndpoint {

    var serviceURL: URL {
        return config.catalogURL
    }

    var authorizationToken: String? { return nil }

}

protocol CheckoutEndpoint: ConfigurableEndpoint { }

extension CheckoutEndpoint {

    var serviceURL: URL {
        return config.checkoutURL
    }

}

protocol CheckoutGatewayEndpoint: ConfigurableEndpoint { }

extension CheckoutGatewayEndpoint {

    var serviceURL: URL {
        return config.checkoutGatewayURL
    }

    var headers: EndpointHeaders? {
        return ["X-UID": clientId, "X-Sales-Channel": salesChannel]
    }

}
