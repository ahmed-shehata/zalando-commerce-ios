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

    private let fullAddressLabel = UILabel()

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

        fullAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        fullAddressLabel.numberOfLines = 0
        contentView.addSubview(fullAddressLabel)
        fullAddressLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor).active = true
        fullAddressLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        fullAddressLabel.trailingAnchor.constraintEqualToAnchor(titleLabel.trailingAnchor).active = true
        fullAddressLabel.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: -Metrics.bottomPadding).active = true
    }

    private func updateViews() {
        titleLabel.text = address.firstName
        fullAddressLabel.text = address.fullAddress
    }

}
