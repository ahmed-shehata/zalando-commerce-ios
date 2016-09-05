//
//  TextFieldInputStackView.swift
//  AtlasUI
//
//  Created by Hani Ibrahim Ibrahim Eloksh on 05/09/16.
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit

class TextFieldInputStackView: UIStackView {

    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFontOfSize(16)
        label.textColor = .blackColor()
        return label
    }()

    internal let textField: UITextField = {
        let textField = UITextField()

        return textField
    }()

}
