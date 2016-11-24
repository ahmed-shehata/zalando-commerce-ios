//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum FormValidator {
    case Required
    case MinLength(minLength: Int)
    case MaxLength(maxLength: Int)
    case ExactLength(length: Int)
    case Pattern(pattern: String, errorMessage: String)
    case NumbersOnly
    case ValidEmail

    func errorMessage(text: String?) -> String? {
        guard !isValid(text) else { return nil }

        switch self {
        case .Required: return Localizer.string("formValidation.required")
        case .MinLength(let minLength): return Localizer.string("formValidation.minLength", "\(minLength)")
        case .MaxLength(let maxLength): return Localizer.string("formValidation.maxLength", "\(maxLength)")
        case .ExactLength(let length): return Localizer.string("formValidation.exactLength", "\(length)")
        case .Pattern(_, let errorMessage): return Localizer.string(errorMessage)
        case .NumbersOnly: return Localizer.string("formValidation.numbersOnly")
        case .ValidEmail: return Localizer.string("formValidation.vaildEmail")
        }
    }

    private static let anyCharacterPattern = "a-zA-ZàÀâÂäÄáÁåÅéÉèÈêÊëËìÌîÎïÏòÒôÔöÖøØùÙûÛüÜçÇñœŒæÆíóúÍÓÚĄąĆćĘęŁłŃńŚśŻżŹź"
    static let namePattern = "^[" + anyCharacterPattern + "]'?[- " + anyCharacterPattern + "ß]+$"
    static let cityPattern = "^[" + anyCharacterPattern + "]'?[-,;()' 0-9" + anyCharacterPattern + "ß]+$"
    static let streetPattern = "^(?=.*[a-zA-Z])(?=.*[0-9]).*$"
    static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

    private func isValid(text: String?) -> Bool {
        switch self {
        case .Required: return text?.trimmedLength > 0
        case .MinLength(let minLength): return text?.trimmedLength >= minLength
        case .MaxLength(let maxLength): return text?.trimmedLength <= maxLength
        case .ExactLength(let length): return text?.trimmedLength == length
        case .Pattern(let pattern, _): return isPatternValid(pattern, text: text)
        case .NumbersOnly: return isPatternValid("^[0-9]+$", text: text)
        case .ValidEmail: return isPatternValid(FormValidator.emailPattern, text: text)
        }
    }

    private func isPatternValid(pattern: String, text: String?) -> Bool {
        guard let trimmedText = text?.trimmed where !trimmedText.isEmpty else { return true }

        let regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        return regex?.firstMatchInString(trimmedText, options: [], range: NSRange(location: 0, length: trimmedText.length)) != nil
    }

}

func == (lhs: FormValidator, rhs: FormValidator) -> Bool {
    switch (lhs, rhs) {
    case (.Required, .Required): return true
    case (.MinLength(let lhsMinLength), .MinLength(let rhsMinLength)): return lhsMinLength == rhsMinLength
    case (.MaxLength(let lhsMaxLength), .MaxLength(let rhsMaxLength)): return lhsMaxLength == rhsMaxLength
    case (.ExactLength(let lhsLength), .ExactLength(let rhsLength)): return lhsLength == rhsLength
    case (.Pattern(let lhsPattern), .Pattern(let rhsPattern)): return lhsPattern == rhsPattern
    case (.NumbersOnly, .NumbersOnly): return true
    case (.ValidEmail, .ValidEmail): return true
    default: return false
    }
}
