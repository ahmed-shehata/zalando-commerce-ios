import Foundation
import AtlasSDK

final class AddressListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView
    private let addresses: [Address]
    private let addressType: AddressType

    private let selectionCompletion: (pickedAddress: Address, pickedAddressType: AddressType) -> Void

    private var selectedAddress: Address? {
        didSet {
            guard let selectedAddress = selectedAddress else { return }
            Async.main {
                self.selectionCompletion(pickedAddress: selectedAddress, pickedAddressType: self.addressType)
            }
        }
    }

    init(addresses: [Address], selectedAddress: Address?, addressType: AddressType,
        addressSelectionCompletion: (pickedAddress: Address, pickedAddressType: AddressType) -> Void) {
            self.addresses = addresses
            self.selectedAddress = selectedAddress
            self.tableView = UITableView()
            self.addressType = addressType
            self.selectionCompletion = addressSelectionCompletion
            super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        setupTableView()
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: 0).active = true
        tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 0).active = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(AddressRowViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(AddressRowViewCell.self, forIndexPath: indexPath) { result in
            switch result {
            case let .dequeuedCell(addressRowCell):
                let address = self.addresses[indexPath.item]
                addressRowCell.address = address
                addressRowCell.accessoryType = self.selectedAddress == address ? .Checkmark : .None
                return addressRowCell
            case let .defaultCell(cell):
                return cell
            }
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPathsToReload = [indexPath]

        if let selectedAddress = selectedAddress, index = addresses.indexOf(selectedAddress) {
            indexPathsToReload.append(NSIndexPath(forItem: index, inSection: 0))
        }

        selectedAddress = addresses[indexPath.item]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths(indexPathsToReload, withRowAnimation: .Automatic)
    }
}
