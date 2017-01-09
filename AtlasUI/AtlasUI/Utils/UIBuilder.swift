//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation
import UIKit

protocol UIBuilder {

    func configureView()
    func configureConstraints()

}

extension UIBuilder {

    func configureView() { }
    func configureConstraints() { }

    func buildView() {
        configureView()
        configureConstraints()

        if let view = self as? UIView {
            view.buildSubviews()
        } else if let viewController = self as? UIViewController {
            viewController.view.buildSubviews()
        }
    }

}

private extension UIView {

    func buildSubviews() {
        self.subviews.forEach { subview in
            if let builder = subview as? UIBuilder {
                builder.buildView()
            } else {
                subview.buildSubviews()
            }
        }
    }

}

protocol UIDataBuilder {

    associatedtype T

    func configure(viewModel: T)

}
