//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import UIKit
import ZalandoCommerceAPI
import ZalandoCommerceUI

class ProfileViewController: UIViewController {

    @IBOutlet fileprivate weak var avatar: UIImageView!
    @IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var email: UILabel!
    @IBOutlet fileprivate weak var customerNumer: UILabel!
    @IBOutlet fileprivate weak var gender: UILabel!

    @IBOutlet fileprivate weak var languageSwitcher: UISegmentedControl!
    @IBOutlet fileprivate weak var environmentSegmentedControl: UISegmentedControl!
    @IBOutlet fileprivate weak var salesChannelSwitcher: UISegmentedControl!

    @IBOutlet fileprivate weak var profileStackView: UIStackView!
    @IBOutlet fileprivate weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        updateSalesChannels()
        updateLanguages()
        updateEnvironmentSelectedIndex()
        updateProfileVisibility()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProfileVisibility(fromNotification:)),
                                               name: .ZalandoCommerceAPIAuthorizationChanged,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func setupViews() {
        self.name.text = ""
        self.email.text = ""
        self.customerNumer.text = ""
        self.gender.text = ""
        self.email.textColor = .gray

        self.profileStackView.alpha = 0
        self.loginButton.alpha = 0
    }

    fileprivate func loadCustomerData() {
        AppSetup.zCommerceUI?.api.customer { result in
            let processedResult = result.processedResult()
            switch processedResult {
            case .success(let customer):
                self.avatar.image = #imageLiteral(resourceName: "user")
                self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
                self.avatar.clipsToBounds = true
                self.name.text = "\(customer.firstName) \(customer.lastName)"
                self.email.text = customer.email
                self.customerNumer.text = customer.customerNumber
                self.gender.text = customer.gender.rawValue

            case .error(_, let title, let message):
                UIAlertController.showMessage(title: title, message: message)

            case .handledInternally:
                break
            }
        }
    }

}

extension ProfileViewController {

    @IBAction func serverSwitched(_ sender: UISegmentedControl) {
        let useSandbox = sender.selectedSegmentIndex == 1
        AppSetup.change(environmentToSandbox: useSandbox)
    }

    @IBAction func languageSwitched(_ sender: UISegmentedControl) {
        let language = InterfaceLanguage(index: sender.selectedSegmentIndex)
        AppSetup.change(interfaceLanguage: language)
    }

    @IBAction func salesChannelChanged(_ sender: UISegmentedControl) {
        let salesChannel = SalesChannel(index: sender.selectedSegmentIndex)
        AppSetup.change(salesChannel: salesChannel)
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        AppSetup.deauthorize()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        loadCustomerData()
    }

}

extension ProfileViewController {

    @objc
    fileprivate func updateProfileVisibility(fromNotification: Notification) {
        updateProfileVisibility()
    }

    fileprivate func updateProfileVisibility(loadData: Bool = true) {
        let showProfile = AppSetup.isAuthorized()

        UIView.animate(withDuration: 0.3) {
            self.profileStackView.alpha = showProfile ? 1 : 0
            self.loginButton.alpha = showProfile ? 0 : 1
        }

        if showProfile && loadData {
            loadCustomerData()
        }
    }

    fileprivate func updateLanguages() {
        self.languageSwitcher.removeAllSegments()
        InterfaceLanguage.all.forEach { language in
            let index = self.languageSwitcher.numberOfSegments
            self.languageSwitcher.insertSegment(withTitle: language.name, at: index, animated: false)
            if language.rawValue == AppSetup.options?.interfaceLanguage {
                self.languageSwitcher.selectedSegmentIndex = index
            }
        }
    }

    fileprivate func updateSalesChannels() {
        self.salesChannelSwitcher.removeAllSegments()
        SalesChannel.all.forEach { salesChannel in
            let index = self.salesChannelSwitcher.numberOfSegments
            self.salesChannelSwitcher.insertSegment(withTitle: salesChannel.name, at: index, animated: false)
            if salesChannel.rawValue == AppSetup.options?.salesChannel {
                self.salesChannelSwitcher.selectedSegmentIndex = index
            }
        }
    }

    fileprivate func updateEnvironmentSelectedIndex() {
        let selectedSegment = AppSetup.options?.useSandboxEnvironment == true ? 1 : 0
        environmentSegmentedControl.selectedSegmentIndex = selectedSegment
    }

}
