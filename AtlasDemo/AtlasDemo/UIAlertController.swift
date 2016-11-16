//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

extension UIAlertController {

    static func showMessage(title title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        dispatch_async(dispatch_get_main_queue()) {
            let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
            navigationController?.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
