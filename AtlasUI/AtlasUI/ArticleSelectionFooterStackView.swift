//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class ArticleSelectionFooterStackView: UIStackView {

    let continueButton: RoundedButton = {
        let button = RoundedButton(type: .custom)
        button.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(Localizer.format(string: "button.general.continue"), for: .normal)
        button.backgroundColor = .orange
        return button
    }()

}

extension ArticleSelectionFooterStackView: UIBuilder {

    func configureView() {
        addArrangedSubview(continueButton)
    }

}
