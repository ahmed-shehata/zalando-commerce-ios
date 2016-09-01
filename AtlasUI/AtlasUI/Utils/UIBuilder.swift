//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

protocol UIBuilder {

    func configureView()
    func configureConstraints()
    func builderSubViews() -> [UIBuilder]

}

extension UIBuilder {

    func configureView() {}
    func configureConstraints() {}
    func builderSubViews() -> [UIBuilder] { return [] }

    func buildView() {
        configureView()
        configureConstraints()
        builderSubViews().forEach { $0.buildView() }
    }

}

protocol UIDataBuilder {

    associatedtype T

    func configureData(viewModel: T)

}
