//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK
import AtlasUI

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var customerNumer: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var languageSwitcher: UISegmentedControl!
    @IBOutlet weak var environmentSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = ""
        self.email.text = ""
        self.customerNumer.text = ""
        self.gender.text = ""
        self.email.textColor = UIColor.grayColor()

        updateLanguageSelectedIndex()
        updateEnvironmentSelectedIndex()
        loadCustomerData()
    }

    @IBAction func serverSwitched(sender: UISegmentedControl) {
        let useSandbox = sender.selectedSegmentIndex == 1
        AppSetup.change(environmentToSandbox: useSandbox)
    }

    @IBAction func languageSwitched(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            AppSetup.change(interfaceLanguage: .Deutsch)
        case 0:
            fallthrough
        default:
            AppSetup.change(interfaceLanguage: .English)
        }
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        Atlas.logoutUser()
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func updateLanguageSelectedIndex() {
        let availableLanguages: [String?] = [AppSetup.InterfaceLanguage.English.rawValue, AppSetup.InterfaceLanguage.Deutsch.rawValue]
        self.languageSwitcher.selectedSegmentIndex = availableLanguages.indexOf { $0 == AppSetup.interfaceLanguage } ?? 0
    }

    private func updateEnvironmentSelectedIndex() {
        let selectedSegment = AppSetup.options?.useSandboxEnvironment == true ? 1 : 0
        environmentSegmentedControl.selectedSegmentIndex = selectedSegment
    }

    private func loadCustomerData() {
        AppSetup.checkout?.client.customer { result in
            switch result {
            case .failure(let error):
                self.showError(title: "Error", error: error)

            case .success(let customer):
                self.avatar.image = UIImage(named: "user")
                self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
                self.avatar.clipsToBounds = true
                self.name.text = "\(customer.firstName) \(customer.lastName)"
                self.email.text = customer.email
                self.customerNumer.text = customer.customerNumber
                self.gender.text = customer.gender.rawValue
            }
        }
    }

}
