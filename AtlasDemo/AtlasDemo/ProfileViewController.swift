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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = ""
        self.email.text = ""
        self.customerNumer.text = ""
        self.gender.text = ""
        self.email.textColor = UIColor.grayColor()
        self.languageSwitcher.selectedSegmentIndex = getLanguageSwitcherSelectedIndex()

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

    @IBAction func languageSwitched(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            AppSetup.switchLanguage("en")
        case 1:
            AppSetup.switchLanguage("de")
        default:
            AppSetup.switchLanguage("en")
        }
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        Atlas.logoutUser()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func getLanguageSwitcherSelectedIndex() -> Int {
        guard let locale = AppSetup.checkout?.client.config.interfaceLocale.objectForKey(NSLocaleLanguageCode) as? String else { return 0 }
        switch locale {
        case "en":
            return 0
        case "de":
            return 1
        default:
            return 0
        }
    }

}
