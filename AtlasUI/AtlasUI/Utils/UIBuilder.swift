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

        let view = (self as? UIView) ?? (self as? UIViewController)?.view
        view?.configureSubviews { (subview: UIBuilder) in subview.buildView() }
    }

}

protocol UIDataBuilder {

    associatedtype T

    func configure(viewModel: T)

}

protocol UIScreenShotBuilder {

    func prepareForScreenShot()
    func cleanupAfterScreenShot()

}

extension UIScreenShotBuilder {

    func prepareSubviewsForScreenShot() {
        prepareForScreenShot()

        let view = (self as? UIView) ?? (self as? UIViewController)?.view
        view?.configureSubviews { (subview: UIScreenShotBuilder) in subview.prepareSubviewsForScreenShot() }
    }

    func cleanupSubviewsAfterScreenShot() {
        cleanupAfterScreenShot()

        let view = (self as? UIView) ?? (self as? UIViewController)?.view
        view?.configureSubviews { (subview: UIScreenShotBuilder) in subview.cleanupSubviewsAfterScreenShot() }
    }

}
