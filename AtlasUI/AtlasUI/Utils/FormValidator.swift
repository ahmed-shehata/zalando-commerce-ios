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

    func rejectionReason(for text: String?) -> String? {
        guard !isValid(text) else { return nil }

        switch self {
        case .required: return Localizer.format(string: "formValidation.required")
        case .minLength(let minLength): return Localizer.format(string: "formValidation.minLength", "\(minLength)")
        case .maxLength(let maxLength): return Localizer.format(string: "formValidation.maxLength", "\(maxLength)")
        case .exactLength(let length): return Localizer.format(string: "formValidation.exactLength", "\(length)")
        case .pattern(_, let errorMessage): return Localizer.format(string: errorMessage)
        case .numbersOnly: return Localizer.format(string: "formValidation.numbersOnly")
        }
    }

    fileprivate static let anyCharacterPattern = "a-zA-ZàÀâÂäÄáÁåÅéÉèÈêÊëËìÌîÎïÏòÒôÔöÖøØùÙûÛüÜçÇñœŒæÆíóúÍÓÚĄąĆćĘęŁłŃńŚśŻżŹź"
    static let namePattern = "^[" + anyCharacterPattern + "]'?[- " + anyCharacterPattern + "ß]+$"
    static let cityPattern = "^[" + anyCharacterPattern + "]'?[-,;()' 0-9" + anyCharacterPattern + "ß]+$"
    static let streetPattern = "^(?=.*[a-zA-Z])(?=.*[0-9]).*$"

    private func isValid(_ text: String?) -> Bool {
        switch self {
        case .required: return trimmedLength(text) > 0
        case .minLength(let minLength): return trimmedLength(text) >= minLength
        case .maxLength(let maxLength): return trimmedLength(text) <= maxLength
        case .exactLength(let length): return text?.trimmed().length == length
        case .pattern(let pattern, _): return isPatternValid(pattern, text: text)
        case .numbersOnly: return isPatternValid("^[0-9]+$", text: text)
        }
    }

    private func trimmedLength(_ text: String?) -> Int {
        return text?.trimmed().length ?? 0
    }

    private func isPatternValid(_ pattern: String, text: String?) -> Bool {
        guard let trimmedText = text?.trimmed(), !trimmedText.isEmpty else { return true }

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex?.firstMatch(in: trimmedText, options: [], range: NSRange(location: 0, length: trimmedText.length)) != nil
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
    default: return false
    }
}
