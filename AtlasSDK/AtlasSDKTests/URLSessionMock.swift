//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

final class URLSessionMock: NSURLSession {
    var url: NSURL?
    var request: NSURLRequest?
    private let dataTaskMock: URLSessionDataTaskMock

    init(data: NSData?, response: NSURLResponse?, error: NSError?) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error)
    }

    override func dataTaskWithURL(url: NSURL,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.url = url
            self.dataTaskMock.completionHandler = completionHandler
            return self.dataTaskMock
    }

    override func dataTaskWithRequest(request: NSURLRequest,
        completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.request = request
            self.dataTaskMock.completionHandler = completionHandler
            return self.dataTaskMock
    }

    final private class URLSessionDataTaskMock: NSURLSessionDataTask {
        typealias CompletionHandler = (NSData!, NSURLResponse!, NSError!) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (NSData?, NSURLResponse?, NSError?)?

        override func resume() {
            completionHandler?(taskResponse?.0, taskResponse?.1, taskResponse?.2)
        }
    }
}
