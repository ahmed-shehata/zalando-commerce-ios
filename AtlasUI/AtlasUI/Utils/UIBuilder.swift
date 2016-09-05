//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol UIBuilder {

    func configureView()
    func configureConstraints()
    func builderSubviews() -> [UIBuilder]

}

extension UIBuilder {

    func configureView() {}
    func configureConstraints() {}
    func builderSubviews() -> [UIBuilder] { return [] }

    func buildView() {
        configureView()
        configureConstraints()
        builderSubviews().forEach { $0.buildView() }
    }

}

protocol UIDataBuilder {

    associatedtype T

    func configureData(viewModel: T)

}
