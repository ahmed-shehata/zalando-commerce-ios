//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class LoaderView: UIView {

    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    fileprivate let backgroundView: RoundedView = {
        let view = RoundedView()
        view.cornerRadius = 20
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        return view
    }()

    func show() {
        activityIndicator.startAnimating()
    }

    func hide() {
        activityIndicator.stopAnimating()
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
