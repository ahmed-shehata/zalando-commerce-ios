//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK

class LoaderView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .White)
    }()

    private let backgroundView: RoundedView = {
        let view = RoundedView()
        view.cornerRadius = 20
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

    internal static func displayLoader(block: (() -> Void) -> Void) {
        let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
        atlasUIViewController?.showLoader()
        block {
            atlasUIViewController?.hideLoader()
        }
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
        backgroundView.setWidth(equalToConstant: 40)
        backgroundView.setHeight(equalToConstant: 40)
        activityIndicator.centerInSuperView()
    }

}
