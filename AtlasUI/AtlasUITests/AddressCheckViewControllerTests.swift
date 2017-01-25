//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI
@testable import AtlasSDK

class AddressCheckViewControllerTests: UITestCase {

    func testSelectingDefaultAddress() {
        let dataModel = createDataModel(streets: ["Mollstrassee 1", "Mollstr. 1"])

        waitUntil(timeout: 10) { done in
            let viewController = AddressCheckViewController(dataModel: dataModel) { result in
                guard case let AddressCheckResult.selectAddress(address: address) = result, address.street == "Mollstr. 1" else { return fail() }
                done()
            }
            self.defaultNavigationController?.pushViewController(viewController, animated: true)
            self.pressSubmitButton(viewController: viewController)
        }
    }

    func testSelectingOriginalAddress() {
        let dataModel = createDataModel(streets: ["Mollstrassee 1", "Mollstr. 1"])

        waitUntil(timeout: 10) { done in
            let viewController = AddressCheckViewController(dataModel: dataModel) { result in
                guard case let AddressCheckResult.selectAddress(address: address) = result, address.street == "Mollstrassee 1" else { return fail() }
                done()
            }
            self.defaultNavigationController?.pushViewController(viewController, animated: true)
            self.selectRow(rowIdx: 0, in: viewController)
            self.pressSubmitButton(viewController: viewController)
        }
    }

    func testSelectingNormalizedAddress() {
        let dataModel = createDataModel(streets: ["Mollstrassee 1", "Mollstr. 1"])

        waitUntil(timeout: 10) { done in
            let viewController = AddressCheckViewController(dataModel: dataModel) { result in
                guard case let AddressCheckResult.selectAddress(address: address) = result, address.street == "Mollstr. 1" else { return fail() }
                done()
            }
            self.defaultNavigationController?.pushViewController(viewController, animated: true)
            self.selectRow(rowIdx: 1, in: viewController)
            self.pressSubmitButton(viewController: viewController)
        }
    }

    func testEditingOriginalAddress() {
        let dataModel = createDataModel(streets: ["Mollstrassee 1", "Mollstr. 1"])

        waitUntil(timeout: 10) { done in
            let viewController = AddressCheckViewController(dataModel: dataModel) { result in
                guard case let AddressCheckResult.editAddress(address: address) = result, address.street == "Mollstrassee 1" else { return fail() }
                done()
            }
            self.defaultNavigationController?.pushViewController(viewController, animated: true)
            self.editRow(rowIdx: 0, in: viewController)
        }
    }

    func testEditingNormalizedAddress() {
        let dataModel = createDataModel(streets: ["Mollstrassee 1", "Mollstr. 1"])

        waitUntil(timeout: 10) { done in
            let viewController = AddressCheckViewController(dataModel: dataModel) { result in
                guard case let AddressCheckResult.editAddress(address: address) = result, address.street == "Mollstr. 1" else { return fail() }
                done()
            }
            self.defaultNavigationController?.pushViewController(viewController, animated: true)
            self.editRow(rowIdx: 1, in: viewController)
        }
    }

}

extension AddressCheckViewControllerTests {

    fileprivate func createDataModel(streets: [String]) -> AddressCheckDataModel {
        return AddressCheckDataModel(header: "Check your Address",
                                     addresses: streets.map { AddressCheckDataModel.Address(title: "Address", address: AddressCheck(withTestData: $0))})
    }

    fileprivate func selectRow(rowIdx: Int, in viewController: AddressCheckViewController) {
        Async.delay(delay: 0.1) {
            let rowView = viewController.rootStackView.addressesRow[rowIdx].view
            guard let action = rowView.selectButton.actions(forTarget: viewController.rootStackView, forControlEvent: .touchUpInside)?.first else { return fail() }
            UIApplication.shared.sendAction(NSSelectorFromString(action), to: viewController.rootStackView, from: rowView.selectButton, for: nil)
        }
    }

    fileprivate func editRow(rowIdx: Int, in viewController: AddressCheckViewController) {
        Async.delay(delay: 0.1) {
            let rowView = viewController.rootStackView.addressesRow[rowIdx].view
            guard let action = rowView.editButton.actions(forTarget: viewController, forControlEvent: .touchUpInside)?.first else { return fail() }
            UIApplication.shared.sendAction(NSSelectorFromString(action), to: viewController, from: rowView.editButton, for: nil)
        }
    }

    fileprivate func pressSubmitButton(viewController: AddressCheckViewController) {
        Async.delay(delay: 0.2) {
            guard let action = viewController.submitButton.actions(forTarget: viewController, forControlEvent: .touchUpInside)?.first else { return fail() }
            UIApplication.shared.sendAction(NSSelectorFromString(action), to: viewController, from: nil, for: nil)
        }
    }

}

private extension AddressCheck {

    init(withTestData street: String) {
        self.street = street
        self.additional = nil
        self.zip = "10178"
        self.city = "Berlin"
        self.countryCode = "DE"
    }

}
