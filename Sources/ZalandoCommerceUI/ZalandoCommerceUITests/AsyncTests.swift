//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import ZalandoCommerceUI

class AsyncTests: XCTestCase {

    func testOperationOnMainQueue() {
        var operationDidRunOnChosenQueue = false
        Async.main {
            operationDidRunOnChosenQueue = self.isRunningOn(qosClass: qos_class_main())
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationNOTOnMainQueue() {
        var operationDidNOTRunOnChosenQueue = true
        Async.main {
            operationDidNOTRunOnChosenQueue = self.isRunningOn(qos: .background)
        }
        expect(operationDidNOTRunOnChosenQueue).toEventually(beFalse())
    }

    func testOperationOnUserInteractiveQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInteractive {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: .userInteractive)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUserInitatedQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInitiated {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: .userInitiated)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUtilityQueue() {
        var operationDidRunOnChosenQueue = false
        Async.utility {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: .utility)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnBackgroundQueue() {
        var operationDidRunOnChosenQueue = false
        Async.background {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: .background)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

}

extension AsyncTests {

    fileprivate func isRunningOn(qos: DispatchQoS.QoSClass) -> Bool {
        return isRunningOn(qosClass: qos.rawValue)
    }

    fileprivate func isRunningOn(qosClass: qos_class_t) -> Bool {
        return qos_class_self() == qosClass
    }

}
