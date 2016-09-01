//
//  LoaderView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    internal let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    }()

    override var hidden: Bool {
        didSet {
            hidden ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
        }
    }
}

extension LoaderView: UIBuilder {

    func configureView() {
        addSubview(activityIndicator)
    }

    func configureConstraints() {
        fillInSuperView()
        activityIndicator.centerInSuperView()
    }

}
