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

    private struct Metrics {
        static let topPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
        static let leadingPadding: CGFloat = 15
        static let trailingPadding: CGFloat = 15
    }

    private func setupViews() {
        contentView.backgroundColor = .clearColor()

        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraintEqualToAnchor(contentView.topAnchor, constant: Metrics.topPadding).active = true
        titleLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: Metrics.leadingPadding).active = true
        titleLabel.trailingAnchor.constraintEqualToAnchor(contentView.trailingAnchor, constant: -Metrics.trailingPadding).active = true

        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        streetLabel.numberOfLines = 0
        contentView.addSubview(streetLabel)
        streetLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor).active = true
        streetLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        streetLabel.trailingAnchor.constraintEqualToAnchor(titleLabel.trailingAnchor).active = true
        streetLabel.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -Metrics.bottomPadding).active = true
    }

    private func updateViews() {
        titleLabel.text = address.firstName

        var lines = [String]()

        if let street = address.street {
            lines.append(street)
        }

        lines.append("\(address.zip) \(address.city)")
        lines.append(address.countryCode)

        streetLabel.text = lines.joinWithSeparator("\n")
    }
}
