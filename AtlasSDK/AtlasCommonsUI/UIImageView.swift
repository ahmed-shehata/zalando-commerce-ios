//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasCommons

extension UIImageView {

    public func setImage(fromUrlString urlString: String) {
        setImage(fromUrl: NSURL(string: urlString))
    }

    public func setImage(fromUrl url: NSURL?) {
        guard let url = url else {
            Async.main {
                self.image = nil
            }
            return
        }
        Async.background {
            guard let data = NSData(contentsOfURL: url) else { return }
            Async.main {
                self.image = UIImage(data: data)
            }
        }
    }

}
