//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasUI

class AsyncTests: XCTestCase {

    func testOperationOnMainQueue() {
        var operationDidRunOnChosenQueue = false
        Async.main {
            operationDidRunOnChosenQueue = self.isRunningOn(queue: DispatchQueue.main)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationNOTOnMainQueue() {
        var operationDidNOTRunOnChosenQueue = true
        Async.main {
            operationDidNOTRunOnChosenQueue = self.isRunningOn(qos: DispatchQoS.QoSClass.background)
        }
        expect(operationDidNOTRunOnChosenQueue).toEventually(beFalse())
    }

    func testOperationOnUserInteractiveQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInteractive {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: DispatchQoS.QoSClass.userInteractive)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUserInitatedQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInitiated {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: DispatchQoS.QoSClass.userInitiated)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUtilityQueue() {
        var operationDidRunOnChosenQueue = false
        Async.utility {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: DispatchQoS.QoSClass.utility)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnBackgroundQueue() {
        var operationDidRunOnChosenQueue = false
        Async.background {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: DispatchQoS.QoSClass.background)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

}

extension AsyncTests {

    fileprivate func isRunningOn(qos: qos_class_t) -> Bool {
        let queue = DispatchQueue.global(qos: qos)
        return isRunningOn(queue: queue)
    }

    fileprivate func isRunningOn(queue: DispatchQueue) -> Bool {
        let currentQueueLabel = DISPATCH_CURRENT_QUEUE_LABEL.label
        let queueLabel = queue.label
        return currentQueueLabel == queueLabel
    }

}
