//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    }()

    private let backgroundView: RoundedView = {
        let view = RoundedView()
        view.cornerRadius = 10
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
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
        userInteractionEnabled = true
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
    }

    func configureConstraints() {
        fillInSuperView()
        backgroundView.centerInSuperView()
        backgroundView.setWidth(equalToConstant: 100)
        backgroundView.setHeight(equalToConstant: 70)
        activityIndicator.centerInSuperView()
    }

}
