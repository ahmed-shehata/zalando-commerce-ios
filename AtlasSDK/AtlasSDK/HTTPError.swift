//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasCommons

public class HTTPError: AtlasError {

    init(code: Int, message: String) {
        super.init(code: code, message: message)
    }

    convenience init(status: HTTPStatus, message: String = "") {
        self.init(code: status.rawValue, message: message)
    }

    convenience init(error: NSError) {
        self.init(code: error.code, message: error.localizedDescription)
    }

}
