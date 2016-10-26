//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import AtlasUI

class URLAuthorizationSpec: QuickSpec {

    override func spec() {

        describe("URLAuthorization") {

            it("should get access token") {
                let accessToken = "access-token-J0ZXN0a2V5LWVzMj"
                // swiftlint:disable:next line_length
                let url = NSURL(string: "http://com.my.app/redirect?access_token=\(accessToken)&token_type=Bearer&expires_in=2592000&scope=atlas-checkout-api.address.all+atlas-checkout-api.order.all+atlas-checkout-api.payment.read+atlas-checkout-api.profile.read+azp+uid&state=")

                expect(url?.accessToken).to(equal(accessToken))
            }

            it("should determine when access was denied") {
                // swiftlint:disable:next line_length
                let deniedURL = NSURL(string: "http://localhost:8080/dummy-callback/oauth?error_description=Resource%20Owner%20did%20not%20authorize%20the%20request&error=access_denied")

                expect(deniedURL?.isAccessDenied).to(beTrue())
            }

            it("should determine when access wasn't denied") {
                let allowedURL = NSURL(string: "http://localhost:8080/redirect#access_token=eyJraWQiOiJ0ZXN0a2")

                expect(allowedURL?.isAccessDenied).to(beFalse())
            }

        }
    }

}
