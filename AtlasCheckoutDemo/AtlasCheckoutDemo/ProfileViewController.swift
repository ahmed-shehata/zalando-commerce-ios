//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import AtlasSDK
import AtlasCheckout
import Haneke

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
                let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)

            case .success(let customer):
                guard let url = NSURL(string: "http://lorempixel.com/80/80/fashion") else { return }
                self.avatar.hnk_setImageFromURL(url)
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
