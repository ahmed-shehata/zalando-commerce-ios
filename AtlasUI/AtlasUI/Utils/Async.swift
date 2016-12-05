//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

struct Async {

    private let workItem: DispatchWorkItem

    private init(workItem: DispatchWorkItem) {
        self.workItem = workItem
    }

    @discardableResult
    static func main(block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: .main, block: block)
    }

    @discardableResult
    static func userInteractive(block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: .userInteractive, block: block)
    }

    @discardableResult
    static func userInitiated(block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: .userInitiated, block: block)
    }

    @discardableResult
    static func utility(block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: .utility, block: block)
    }

    @discardableResult
    static func background(block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: .background, block: block)
    }

    private static func dispatchAsync(on qos: DispatchQoS.QoSClass, block: @escaping () -> ()) -> Async {
        return dispatchAsync(on: DispatchQueue.global(qos: qos), block: block)
    }

    private static func dispatchAsync(on queue: DispatchQueue, block: @escaping () -> ()) -> Async {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return Async(workItem: workItem)
    }

}
