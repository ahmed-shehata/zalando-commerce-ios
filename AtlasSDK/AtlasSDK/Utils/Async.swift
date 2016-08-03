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

public struct Async {

    private let block: dispatch_block_t

    private init(_ block: dispatch_block_t) {
        self.block = block
    }

    public static func main(block: dispatch_block_t) -> Async {
        return run(inQueue: Queues.main(), block: block)
    }

    public static func userInteractive(block: dispatch_block_t) -> Async {
        return run(inQueue: Queues.userInteractive(), block: block)
    }

    public static func userInitiated(block: dispatch_block_t) -> Async {
        return run(inQueue: Queues.userInitiated(), block: block)
    }

    public static func utility(block: dispatch_block_t) -> Async {
        return run(inQueue: Queues.utility(), block: block)
    }

    public static func background(block: dispatch_block_t) -> Async {
        return run(inQueue: Queues.background(), block: block)
    }

    private static func run(inQueue queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
        return Async.dispatchAsync(queue, block: block)
    }

    private static func dispatchAsync(queue: dispatch_queue_t, block: dispatch_block_t) -> Async {
        let _block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, block)
        dispatch_async(queue, _block)
        return Async(_block)
    }

}
