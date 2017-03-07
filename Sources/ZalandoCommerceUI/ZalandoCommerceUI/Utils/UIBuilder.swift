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

protocol UIScreenshotBuilder {

    func prepareForScreenshot()
    func cleanupAfterScreenshot()

}

extension UIScreenshotBuilder {

    func prepareSubviewsForScreenshot() {
        prepareForScreenshot()

        let view = (self as? UIView) ?? (self as? UIViewController)?.view
        view?.configureSubviews { (subview: UIScreenshotBuilder) in subview.prepareSubviewsForScreenshot() }
    }

    func cleanupSubviewsAfterScreenshot() {
        cleanupAfterScreenshot()

        let view = (self as? UIView) ?? (self as? UIViewController)?.view
        view?.configureSubviews { (subview: UIScreenshotBuilder) in subview.cleanupSubviewsAfterScreenshot() }
    }

}
