//
//  EditAddressViewController.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 05/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class EditAddressViewController: UIViewController {

    internal let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    internal let addressStackView: EditAddressStackView = {
        let stackView = EditAddressStackView()
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        buildView()
    }

}

extension EditAddressViewController: UIBuilder {

    func configureView() {
        view.addSubview(scrollView)
        scrollView.addSubview(addressStackView)
    }

    func configureConstraints() {
        scrollView.fillInSuperView()
        addressStackView.fillInSuperView()
        addressStackView.setWidth(equalToView: scrollView)
    }

    func builderSubviews() -> [UIBuilder] {
        return [addressStackView]
    }
}
