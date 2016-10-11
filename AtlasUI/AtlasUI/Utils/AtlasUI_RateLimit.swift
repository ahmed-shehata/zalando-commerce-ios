// swiftlint:disable type_name

//
//  RateLimit.swift
//  RateLimit
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright © 2012-2015 Sam Soffes. All rights reserved.
//

import Foundation

public class AtlasUI_RateLimit: NSObject {

    internal class func execute(name name: String, limit: NSTimeInterval, @noescape block: Void -> ()) -> Bool {
        if shouldExecute(name: name, limit: limit) {
            block()
            return true
        }

        return false
    }

    private class func resetLimitForName(name: String) {
        dispatch_sync(queue) {
            dictionary.removeValueForKey(name)
        }
    }

    private class func resetAllLimits() {
        dispatch_sync(queue) {
            dictionary.removeAll()
        }
    }


    // MARK: - Private

    private static let queue = dispatch_queue_create("com.atlasUI.ratelimit", DISPATCH_QUEUE_SERIAL)

    private static var dictionary = [String: NSDate]() {
        didSet {
            didChangeDictionary()
        }
    }

    private class func didChangeDictionary() {
        // Do nothing
    }

    private class func shouldExecute(name name: String, limit: NSTimeInterval) -> Bool {
        var should = false

        dispatch_sync(queue) {
            // Lookup last executed
            if let lastExecutedAt = dictionary[name] {
                let timeInterval = lastExecutedAt.timeIntervalSinceNow

                // If last excuted is less than the limit, don't execute
                should = !(timeInterval < 0 && abs(timeInterval) < limit)
            } else {
                should = true
            }

            // Record execution
            dictionary[name] = NSDate()
        }

        return should
    }
}
