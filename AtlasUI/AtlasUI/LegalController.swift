//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class LegalController: NSObject {

    private let tocURL: NSURL
    private let legalURL: NSURL

    private let legalURLPath = "/legal/"

    required init(tocURL: NSURL) {
        self.tocURL = tocURL
        self.legalURL = NSURL(validURL: tocURL, path: legalURLPath)
    }

    func presentLegalViewController() {
        guard let navController = AtlasUIViewController.instance?.mainNavigationController else {
            UIApplication.sharedApplication().openURL(tocURL)
            return
        }

        let tocController = ToCViewController()
        navController.pushViewController(tocController, animated: true)

        tocController.load(url: legalURL) { url, _, status in
            if !status.isSuccessful {
                tocController.load(url: self.tocURL)
            }
        }
    }

}
