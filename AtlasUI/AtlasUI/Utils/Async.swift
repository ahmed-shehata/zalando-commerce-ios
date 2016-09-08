//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

private struct Queues {

    static func main() -> dispatch_queue_t {
        return dispatch_get_main_queue()
    }

    static func userInteractive() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
    }

    static func userInitiated() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }

    static func utility() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
    }

    static func background() -> dispatch_queue_t {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }

}

struct Async {

    private let block: dispatch_block_t

    private init(_ block: dispatch_block_t) {
        self.block = block
    }

    static func main(block: dispatch_block_t) -> Async {
        return dispatchAsync(Queues.main(), block: block)
    }

    static func delay(delay: NSTimeInterval, block: dispatch_block_t) -> Async {
        return dispatchAsyncDelay(delay, queue: Queues.main(), block: block)
    }

    static func userInteractive(block: dispatch_block_t) -> Async {
        return dispatchAsync(Queues.userInteractive(), block: block)
    }

    static func userInitiated(block: dispatch_block_t) -> Async {
        return dispatchAsync(Queues.userInitiated(), block: block)
    }

    static func utility(block: dispatch_block_t) -> Async {
        return dispatchAsync(Queues.utility(), block: block)
    }

    static func background(block: dispatch_block_t) -> Async {
        return dispatchAsync(Queues.background(), block: block)
    }

    private static func dispatchAsync(queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
        let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        dispatch_async(queue, _block)
        return Async(_block)
    }

    private static func dispatchAsyncDelay(delay: NSTimeInterval, queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
        let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, _block)
        return Async(_block)
    }

}
