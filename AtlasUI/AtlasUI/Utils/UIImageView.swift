//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

extension UIImageView {

    func setImage(from url: URL?) {
        guard let url = url else {
            Async.main {
                self.image = nil
            }
            return
        }
        Async.background {
            guard let data = try? Data(contentsOf: url) else { return }
            Async.main {
                self.image = UIImage(data: data)
            }
        }
    }

}
