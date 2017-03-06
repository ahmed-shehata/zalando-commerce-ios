//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit
import AtlasSDK

final class LegalController: NSObject {

    fileprivate let tocURL: URL
    fileprivate let legalURL: URL

    fileprivate let legalURLPath = "/legal/"

    required init(tocURL: URL) {
        self.tocURL = tocURL
        self.legalURL = URL(validURL: tocURL, path: legalURLPath)
    }

    func push(on navController: UINavigationController? = AtlasUIViewController.presented?.mainNavigationController) {
        guard let navController = navController else {
            UIApplication.shared.openURL(tocURL)
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
