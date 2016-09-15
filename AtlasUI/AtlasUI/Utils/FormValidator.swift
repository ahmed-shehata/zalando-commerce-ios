//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

enum FormValidator {
    case Required
    case MinLength(minLength: Int)
    case MaxLength(maxLength: Int)
    case Pattern(pattern: String)

    internal func errorMessage(text: String?, localizer: LocalizerProviderType) -> String? {
        guard !isValid(text) else { return nil }
        return errorMessage(localizer)
    }

    internal static let anyCharacterPattern = "a-zA-ZàÀâÂäÄáÁåÅéÉèÈêÊëËìÌîÎïÏòÒôÔöÖøØùÙûÛüÜçÇñœŒæÆíóúÍÓÚĄąĆćĘęŁłŃńŚśŻżŹź"

    private func isValid(text: String?) -> Bool {
        switch self {
        case .Required: return text?.trimmedLength > 0
        case .MinLength(let minLength): return text?.trimmedLength >= minLength
        case .MaxLength(let maxLength): return text?.trimmedLength <= maxLength
        case .Pattern(let pattern): return isPatternValid(pattern, text: text)
        }
    }

    private func isPatternValid(pattern: String, text: String?) -> Bool {
        guard let trimmedText = text?.trimmed where !trimmedText.isEmpty else { return true }

        let regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        return regex?.firstMatchInString(trimmedText, options: [], range: NSRange(location: 0, length: trimmedText.length)) != nil
    }

    private func errorMessage(localizer: LocalizerProviderType) -> String {
        switch self {
        case .Required: return localizer.loc("Form.validation.required")
        case .MinLength(let minLength): return localizer.loc("Form.validation.minLength: %@", "\(minLength)")
        case .MaxLength(let maxLength): return localizer.loc("Form.validation.maxLength: %@", "\(maxLength)")
        case .Pattern: return localizer.loc("Form.validation.pattern")
        }
    }

}
