//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias TextFieldChangedHandler = String? -> Void

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let error: String?
    let isActive: Bool
    let customInputView: UIView?
    let nextTextFieldInput: TextFieldInputStackView?
    let valueChangedHandler: TextFieldChangedHandler?

    init (title: String,
          value: String? = nil,
          error: String? = nil,
          isActive: Bool = true,
          customInputView: UIView? = nil,
          nextTextFieldInput: TextFieldInputStackView? = nil,
          valueChangedHandler: TextFieldChangedHandler? = nil) {

        self.title = title
        self.value = value
        self.error = error
        self.isActive = isActive
        self.customInputView = customInputView
        self.nextTextFieldInput = nextTextFieldInput
        self.valueChangedHandler = valueChangedHandler
    }
}
