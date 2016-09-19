//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias TextFieldChangedHandler = String? -> Void

struct TextFieldInputViewModel {
    let title: String
    let value: String?
    let isActive: Bool
    let validators: [FormValidator]
    let localizer: LocalizerProviderType
    let customInputView: UIView?
    let nextTextFieldInput: TextFieldInputStackView?
    let valueChangedHandler: TextFieldChangedHandler?

    init (title: String,
          value: String? = nil,
          isActive: Bool = true,
          validators: [FormValidator] = [],
          localizer: LocalizerProviderType,
          customInputView: UIView? = nil,
          nextTextFieldInput: TextFieldInputStackView? = nil,
          valueChangedHandler: TextFieldChangedHandler? = nil) {

        self.title = title
        self.value = value
        self.isActive = isActive
        self.validators = validators
        self.localizer = localizer
        self.customInputView = customInputView
        self.nextTextFieldInput = nextTextFieldInput
        self.valueChangedHandler = valueChangedHandler
    }
}
