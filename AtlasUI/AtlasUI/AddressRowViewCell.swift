//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
import AtlasSDK

final class AddressRowViewCell: UITableViewCell {

    var address: Address! {
        didSet {
            updateViews()
        }
    }

    private let titleLabel = UILabel()

    private let streetLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.backgroundColor = .clearColor()

        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        streetLabel.numberOfLines = 0
        contentView.addSubview(streetLabel)
        streetLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor).active = true
        streetLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        streetLabel.trailingAnchor.constraintEqualToAnchor(titleLabel.trailingAnchor).active = true
        streetLabel.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -10).active = true
    }

    private func updateViews() {
        titleLabel.text = address.firstName
        if let street = address.street {
            streetLabel.text = [street, "\(address.zip) \(address.city)", address.countryCode].flatMap { $0 }.joinWithSeparator("\n")
        }
    }
}
