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
            operationDidRunOnChosenQueue = self.isRunningOn(queue: dispatch_get_main_queue())
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationNOTOnMainQueue() {
        var operationDidNOTRunOnChosenQueue = true
        Async.main {
            operationDidNOTRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_BACKGROUND)
        }
        expect(operationDidNOTRunOnChosenQueue).toEventually(beFalse())
    }

    func testOperationOnUserInteractiveQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInteractive {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_USER_INTERACTIVE)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUserInitatedQueue() {
        var operationDidRunOnChosenQueue = false
        Async.userInitiated {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_USER_INITIATED)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnUtilityQueue() {
        var operationDidRunOnChosenQueue = false
        Async.utility {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_UTILITY)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

    func testOperationOnBackgroundQueue() {
        var operationDidRunOnChosenQueue = false
        Async.background {
            operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_BACKGROUND)
        }
        expect(operationDidRunOnChosenQueue).toEventually(beTrue())
    }

}

extension AsyncTests {

    private func isRunningOn(qos qos: qos_class_t) -> Bool {
        let queue = dispatch_get_global_queue(qos, 0)
        return isRunningOn(queue: queue)
    }

    private func isRunningOn(queue queue: dispatch_queue_t) -> Bool {
        let currentQueueLabel = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)
        let queueLabel = dispatch_queue_get_label(queue)
        return currentQueueLabel == queueLabel
    }

}
