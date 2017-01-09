//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import Foundation

extension UIAlertController {

    static func showMessage(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        DispatchQueue.main.async {
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            navigationController?.present(alertView, animated: true, completion: nil)
        }
    }

}
