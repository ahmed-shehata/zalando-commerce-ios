//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

extension Gender {

    func title(localizer: LocalizerProviderType) -> String {
        switch self {
        case .male: return localizer.loc("Address.edit.gender.male")
        case .female: return localizer.loc("Address.edit.gender.female")
        }
    }

    init?(localizedGenderText: String?, localizer: LocalizerProviderType) {
        guard let text = localizedGenderText else { return nil }
        switch text {
        case Gender.male.title(localizer): self = .male
        case Gender.female.title(localizer): self = .female
        default: return nil
        }
    }

}
