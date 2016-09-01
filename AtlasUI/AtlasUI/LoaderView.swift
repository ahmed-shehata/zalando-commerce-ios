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
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

        return loader
    }()

}
