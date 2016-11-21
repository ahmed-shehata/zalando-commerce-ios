//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

enum FormValidator {
    case required
    case minLength(minLength: Int)
    case maxLength(maxLength: Int)
    case exactLength(length: Int)
    case pattern(pattern: String, errorMessage: String)
    case numbersOnly

    func errorMessage(_ text: String?) -> String? {
        guard !isValid(text) else { return nil }

        switch self {
        case .required: return Localizer.string("formValidation.required")
        case .minLength(let minLength): return Localizer.string("formValidation.minLength", "\(minLength)")
        case .maxLength(let maxLength): return Localizer.string("formValidation.maxLength", "\(maxLength)")
        case .exactLength(let length): return Localizer.string("formValidation.exactLength", "\(length)")
        case .pattern(_, let errorMessage): return Localizer.string(errorMessage)
        case .numbersOnly: return Localizer.string("formValidation.numbersOnly")
        }
    }

    fileprivate static let anyCharacterPattern = "a-zA-ZàÀâÂäÄáÁåÅéÉèÈêÊëËìÌîÎïÏòÒôÔöÖøØùÙûÛüÜçÇñœŒæÆíóúÍÓÚĄąĆćĘęŁłŃńŚśŻżŹź"
    static let namePattern = "^[" + anyCharacterPattern + "]'?[- " + anyCharacterPattern + "ß]+$"
    static let cityPattern = "^[" + anyCharacterPattern + "]'?[-,;()' 0-9" + anyCharacterPattern + "ß]+$"
    static let streetPattern = "^(?=.*[a-zA-Z])(?=.*[0-9]).*$"

    fileprivate func isValid(_ text: String?) -> Bool {
        switch self {
        case .required: return text?.trimmed().length > 0
        case .minLength(let minLength): return text?.trimmed().length >= minLength
        case .maxLength(let maxLength): return text?.trimmed().length <= maxLength
        case .exactLength(let length): return text?.trimmed().length == length
        case .pattern(let pattern, _): return isPatternValid(pattern, text: text)
        case .numbersOnly: return isPatternValid("^[0-9]+$", text: text)
        }
    }

    fileprivate func isPatternValid(_ pattern: String, text: String?) -> Bool {
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
