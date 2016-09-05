import Foundation
import AtlasSDK

final class AddressListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckoutProviderType {

    private let tableView = UITableView()
    private var addresses: [Address]
    private let addressType: AddressType
    internal var checkout: AtlasCheckout

    private let selectionCompletion: AddressSelectionCompletion

    private var selectedAddress: Address? {
        didSet {
            Async.main { [weak self] in
                guard let strongSelf = self, selectedAddress = strongSelf.selectedAddress else { return }
                strongSelf.selectionCompletion(pickedAddress: selectedAddress, pickedAddressType: strongSelf.addressType)
            }
        }
    }

    init(checkout: AtlasCheckout, addresses: [Address], selectedAddress: Address?, addressType: AddressType,
        addressSelectionCompletion: AddressSelectionCompletion) {
            self.addresses = addresses
            self.selectedAddress = selectedAddress
            self.addressType = addressType
            self.selectionCompletion = addressSelectionCompletion
            self.checkout = checkout
            super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        self.view.addSubview(tableView)
        setupTableView()
    }

    func setupTableView() {

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.fillInSuperView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(AddressRowViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.parentViewController?.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let address = self.addresses[indexPath.item]
                checkout.client.deleteAddress(address.id) { result in
                    switch result {
                    case .success(_):
                        self.addresses.removeAtIndex(indexPath.item)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    case .failure(let error):
                        self.userMessage.show(error: error)
                    }
                }
            }
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
