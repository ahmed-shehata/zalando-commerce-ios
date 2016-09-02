import Foundation
import AtlasSDK

final class AddressListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate: AddressListViewControllerDelegate?
    let tableView: UITableView
    private let addresses: [Address]

    private var selectedAddress: Address? {
        didSet {
            guard let selectedAddress = selectedAddress else { return }
            Async.main {
                self.delegate?.addressListViewController(self, didSelectAddress: selectedAddress)
            }
        }
    }

    init(addresses: [Address], selectedAddress: Address?) {
        self.addresses = addresses
        self.selectedAddress = selectedAddress
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(AddressRowViewCell.self, forCellReuseIdentifier: String(AddressRowViewCell))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            String(AddressRowViewCell), forIndexPath: indexPath) as! AddressRowViewCell
        let address = addresses[indexPath.item]
        cell.address = address

        if selectedAddress == address {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
