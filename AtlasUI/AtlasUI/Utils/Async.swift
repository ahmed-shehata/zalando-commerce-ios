//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

private struct Queues {

    static func main() -> DispatchQueue {
        return DispatchQueue.main
    }

    static func userInteractive() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    }

    static func userInitiated() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    }

    static func utility() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    }

    static func background() -> DispatchQueue {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }

}

struct Async {

    fileprivate let workItem: DispatchWorkItem

    fileprivate init(workItem: DispatchWorkItem) {
        self.workItem = workItem
    }

    @discardableResult
    static func main(_ block: @escaping ()->()) -> Async {
        return dispatchAsync(Queues.main(), block: block)
    }

    @discardableResult
    static func userInteractive(_ block: @escaping ()->()) -> Async {
        return dispatchAsync(Queues.userInteractive(), block: block)
    }

    @discardableResult
    static func userInitiated(_ block: @escaping ()->()) -> Async {
        return dispatchAsync(Queues.userInitiated(), block: block)
    }

    @discardableResult
    static func utility(_ block: @escaping ()->()) -> Async {
        return dispatchAsync(Queues.utility(), block: block)
    }

    @discardableResult
    static func background(_ block: @escaping ()->()) -> Async {
        return dispatchAsync(Queues.background(), block: block)
    }

    fileprivate static func dispatchAsync(_ queue: DispatchQueue, block: @escaping ()->()) -> Async {
        let workItem = DispatchWorkItem(block: block)
        queue.async(execute: workItem)
        return Async(workItem: workItem)
    }

}
