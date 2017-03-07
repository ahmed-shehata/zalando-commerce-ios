//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import Foundation

struct Async {

    private let workItem: DispatchWorkItem

    private init(workItem: DispatchWorkItem) {
        self.workItem = workItem
    }

    @discardableResult
    static func main(block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .main, block: block)
    }

    @discardableResult
    static func delay(delay: TimeInterval, block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .main, after: delay, block: block)
    }

    @discardableResult
    static func userInteractive(block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .userInteractive, block: block)
    }

    @discardableResult
    static func userInitiated(block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .userInitiated, block: block)
    }

    @discardableResult
    static func utility(block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .utility, block: block)
    }

    @discardableResult
    static func background(block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: .background, block: block)
    }

    private static func dispatchAsync(on qos: DispatchQoS.QoSClass, block: @escaping () -> Void) -> Async {
        return dispatchAsync(on: DispatchQueue.global(qos: qos), block: block)
    }

    private static func dispatchAsync(on queue: DispatchQueue, after delay: TimeInterval = 0, block: @escaping () -> Void) -> Async {
        let workItem = DispatchWorkItem(block: block)
        if delay == 0 {
            queue.async(execute: workItem)
        } else {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
        return Async(workItem: workItem)
    }

}
