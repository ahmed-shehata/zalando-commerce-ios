import Foundation
import AtlasSDK

final class AddressListViewController: UITableViewController {

    var delegate: AddressListViewControllerDelegate?

    private let addresses: [Address]

    private var selectedAddress: Address? {
        didSet {
            if let selectedAddress = selectedAddress {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.addressListViewController(self, didSelectAddress: selectedAddress)
                }
            }
        }
    }

    init(addresses: [Address], selectedAddress: Address?) {
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(AddressRowViewCell.self, forCellReuseIdentifier: String(AddressRowViewCell))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(
            String(AddressRowViewCell), forIndexPath: indexPath) as? AddressRowViewCell else {
                fatalError("Failed to dequeue an AddressRowViewCell")
        }
        let address = addresses[indexPath.item]
        cell.address = address

        if let selectedAddress = selectedAddress where selectedAddress == address {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPathsToReload = [indexPath]

        if let selectedAddress = selectedAddress, index = addresses.indexOf(selectedAddress) {
            indexPathsToReload.append(NSIndexPath(forItem: index, inSection: 0))
        }

        let address = addresses[indexPath.item]
        selectedAddress = address
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
    }
}
