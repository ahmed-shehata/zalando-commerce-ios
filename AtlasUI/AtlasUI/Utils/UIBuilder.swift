//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol UIBuilder {

    func configureView()
    func configureConstraints()

}

extension UIBuilder {

    func configureView() {}
    func configureConstraints() {}

    func buildView() {
        configureView()
        configureConstraints()

        if let view = self as? UIView {
            buildSubViews(view)
        } else if let viewController = self as? UIViewController {
            buildSubViews(viewController.view)
        }
    }

    func buildSubViews(_ rootView: UIView) {
        rootView.subviews.forEach { subview in
            if let builder = subview as? UIBuilder {
                builder.buildView()
            } else {
                buildSubViews(subview)
            }
        }
    }

}

protocol UIDataBuilder {

    associatedtype T

    func configure(viewModel: T)

}
