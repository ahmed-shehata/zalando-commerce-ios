//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    }()

    internal func show() {
        activityIndicator.startAnimating()
        hidden = false
    }

    internal func hide() {
        activityIndicator.stopAnimating()
        hidden = true
    }

}

extension LoaderView: UIBuilder {

    func configureView() {
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        addSubview(activityIndicator)
    }

    func configureConstraints() {
        fillInSuperView()
        activityIndicator.centerInSuperView()
    }

}
