//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK
import AtlasUI

extension AtlasAPIResult {

    func process() -> T? {
        let processedResult = self.processedResult()
        switch processedResult {
        case .success(let data):
            return data
        case .error(_, let title, let message):
            showMessage(title: title, message: message)
            return nil
        case .handledInternally:
            return nil
        }
    }

    private func showMessage(title title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        dispatch_async(dispatch_get_main_queue()) {
            let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
            navigationController?.presentViewController(alertView, animated: true, completion: nil)
        }
    }

}
