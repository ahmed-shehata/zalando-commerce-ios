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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.name.text = ""
        self.email.text = ""
        self.customerNumer.text = ""
        self.gender.text = ""

        self.email.textColor = UIColor.grayColor()

        AtlasSDK.fetchCustomer { result in
            switch result {
            case .failure(let error):
                UserMessage.showError(title: "Error", error: error)

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

    @IBAction func payNowButtonTapped(sender: AnyObject) {
//        showPaymentScreen()
    }
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        AtlasSDK.logoutCustomer()
        self.navigationController?.popViewControllerAnimated(true)
    }

}
