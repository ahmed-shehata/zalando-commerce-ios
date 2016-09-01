//
//  UIBuilder.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 01/09/16.
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
