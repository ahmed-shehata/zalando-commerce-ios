//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum FormValidator {
    case required
    case minLength(minLength: Int)
    case maxLength(maxLength: Int)
    case exactLength(length: Int)
    case pattern(pattern: String, errorMessage: String)
    case numbersOnly
    case validEmail

    func rejectionReason(for text: String?) -> String? {
        guard !isValid(text) else { return nil }

        switch self {
        case .required: return Localizer.format(string: "formValidation.required")
        case .minLength(let minLength): return Localizer.format(string: "formValidation.minLength", "\(minLength)")
        case .maxLength(let maxLength): return Localizer.format(string: "formValidation.maxLength", "\(maxLength)")
        case .exactLength(let length): return Localizer.format(string: "formValidation.exactLength", "\(length)")
        case .pattern(_, let errorMessage): return Localizer.format(string: errorMessage)
        case .numbersOnly: return Localizer.format(string: "formValidation.numbersOnly")
        case .validEmail: return Localizer.format(string: "formValidation.vaildEmail")
        }
    }

    fileprivate static let anyCharacterPattern = "a-zA-ZàÀâÂäÄáÁåÅéÉèÈêÊëËìÌîÎïÏòÒôÔöÖøØùÙûÛüÜçÇñœŒæÆíóúÍÓÚĄąĆćĘęŁłŃńŚśŻżŹź"
    static let namePattern = "^[" + anyCharacterPattern + "]'?[- " + anyCharacterPattern + "ß]+$"
    static let cityPattern = "^[" + anyCharacterPattern + "]'?[-,;()' 0-9" + anyCharacterPattern + "ß]+$"
    static let streetPattern = "^(?=.*[a-zA-Z])(?=.*[0-9]).*$"
    static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static let digitsPattern = "^[0-9]+$"

    private func isValid(_ text: String?) -> Bool {
        switch self {
        case .required: return trimmedLength(text) > 0
        case .minLength(let minLength): return trimmedLength(text) >= minLength
        case .maxLength(let maxLength): return trimmedLength(text) <= maxLength
        case .exactLength(let length): return text?.trimmed().length == length
        case .pattern(let pattern, _): return isValid(pattern: pattern, text: text)
        case .numbersOnly: return isValid(pattern: FormValidator.digitsPattern, text: text)
        case .validEmail: return isValid(pattern: FormValidator.emailPattern, text: text)
        }
    }

    private func trimmedLength(_ text: String?) -> Int {
        return text?.trimmed().length ?? 0
    }

    private func isValid(pattern: String, text: String?) -> Bool {
        guard let trimmedText = text?.trimmed(), !trimmedText.isEmpty else { return true }
        return trimmedText.matches(pattern: pattern)
    }

}

func == (lhs: FormValidator, rhs: FormValidator) -> Bool {
    switch (lhs, rhs) {
    case (.required, .required): return true
    case (.minLength(let lhsMinLength), .minLength(let rhsMinLength)): return lhsMinLength == rhsMinLength
    case (.maxLength(let lhsMaxLength), .maxLength(let rhsMaxLength)): return lhsMaxLength == rhsMaxLength
    case (.exactLength(let lhsLength), .exactLength(let rhsLength)): return lhsLength == rhsLength
    case (.pattern(let lhsPattern), .pattern(let rhsPattern)): return lhsPattern == rhsPattern
    case (.numbersOnly, .numbersOnly): return true
    case (.validEmail, .validEmail): return true
    default: return false
    }
}
