//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI

class URLAuthorizationTests: XCTestCase {

    func testGetAccessToken() {
        let accessToken = "access-token-J0ZXN0a2V5LWVzMj"
        let url = URL(string: "http://com.my.app/redirect?access_token=\(accessToken)&token_type=Bearer&expires_in=2592000&scope=atlas-checkout-api.address.all+atlas-checkout-api.order.all+atlas-checkout-api.payment.read+atlas-checkout-api.profile.read+azp+uid&state=")

        expect(url?.accessToken) == accessToken
    }

    func testAccessDenied() {
        let deniedURL = URL(string: "http://localhost:8080/dummy-callback/oauth?error_description=Resource%20Owner%20did%20not%20authorize%20the%20request&error=access_denied")

        expect(deniedURL?.isAccessDenied).to(beTrue())
    }

    func testAccessNotDenied() {
        let allowedURL = URL(string: "http://localhost:8080/redirect#access_token=eyJraWQiOiJ0ZXN0a2")

        expect(allowedURL?.isAccessDenied).to(beFalse())
    }

}
