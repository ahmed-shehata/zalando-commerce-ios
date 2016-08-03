//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Quick
import Nimble
@testable import AtlasSDK

class AsyncSpec: QuickSpec {

    override func spec() {
        describe("Async operations") {

            var operationDidRunOnChosenQueue = false

            beforeEach {
                operationDidRunOnChosenQueue = false
            }

            it("Operation did run on main queue") {
                Async.main {
                    operationDidRunOnChosenQueue = self.isRunningOn(queue: dispatch_get_main_queue())
                }

                expect(operationDidRunOnChosenQueue).toEventually(beTrue())
            }

            it("Operation did run on user interactive queue") {
                Async.userInteractive {
                    operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_USER_INTERACTIVE)
                }

                expect(operationDidRunOnChosenQueue).toEventually(beTrue())
            }

            it("Operation did run on user initated queue") {
                Async.userInitiated {
                    operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_USER_INITIATED)
                }

                expect(operationDidRunOnChosenQueue).toEventually(beTrue())
            }

            it("Operation did run on utility queue") {
                Async.utility {
                    operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_UTILITY)
                }

                expect(operationDidRunOnChosenQueue).toEventually(beTrue())
            }

            it("Operation did run on background queue") {
                Async.background {
                    operationDidRunOnChosenQueue = self.isRunningOn(qos: QOS_CLASS_BACKGROUND)
                }

                expect(operationDidRunOnChosenQueue).toEventually(beTrue())
            }

        }
    }

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
