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
    @IBOutlet weak var serverSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = ""
        self.email.text = ""
        self.customerNumer.text = ""
        self.gender.text = ""
        self.email.textColor = UIColor.grayColor()
        self.languageSwitcher.selectedSegmentIndex = getLanguageSwitcherSelectedIndex()

        serverSegmentedControl.selectedSegmentIndex = 0
        if let useSandbox = AppSetup.options?.useSandboxEnvironment {
            if useSandbox {
                serverSegmentedControl.selectedSegmentIndex = 1
            }
        }

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

    @IBAction func serverSwitched(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 1:
            AppSetup.change(environmentToSandbox: true)
        case 0:
            fallthrough
        default:
            AppSetup.change(environmentToSandbox: false)
        }

    }
    @IBAction func languageSwitched(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            AppSetup.change(interfaceLanguage: "de")
        case 0:
            fallthrough
        default:
            AppSetup.change(interfaceLanguage: "en")
        }
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        Atlas.logoutUser()
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func getLanguageSwitcherSelectedIndex() -> Int {
        guard let languageCode = AppSetup.interfaceLanguage else { return 0 }
        return ["en", "de"].indexOf(languageCode) ?? 0
    }

}
