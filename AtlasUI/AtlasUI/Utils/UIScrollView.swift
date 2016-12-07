//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

extension UIScrollView {

    override func takeScreenshot() -> UIImage? {
        let savedContentOffset = contentOffset
        let savedFrame = frame

        contentOffset = .zero
        frame = CGRect(origin: CGPoint.zero, size: contentSize)

        let image = super.takeScreenshot()

        contentOffset = savedContentOffset
        frame = savedFrame

        return image
    }

}
