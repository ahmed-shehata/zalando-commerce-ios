//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class LoaderView: UIView {

    fileprivate let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .white)
    }()

    fileprivate let backgroundView: RoundedView = {
        let view = RoundedView()
        view.cornerRadius = 20
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
    }()

    func show() {
        activityIndicator.startAnimating()
        isHidden = false
    }

    func hide() {
        activityIndicator.stopAnimating()
        isHidden = true
    }

}

extension LoaderView: UIBuilder {

    func configureView() {
        isUserInteractionEnabled = true
        addSubview(backgroundView)
        backgroundView.addSubview(activityIndicator)
    }

    func configureConstraints() {
        fillInSuperview()
        backgroundView.centerInSuperview()
        backgroundView.setWidth(equalToConstant: 40)
        backgroundView.setHeight(equalToConstant: 40)
        activityIndicator.centerInSuperview()
    }

}
