//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias CompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void
typealias TaskResponse = (data: NSData?, response: NSURLResponse?, error: NSError?)

final class URLSessionMock: NSURLSession {

    var url: NSURL?
    var request: NSURLRequest?
    private let dataTaskMock: URLSessionDataTaskMock

    init(data: NSData?, response: NSURLResponse?, error: NSError?) {
        dataTaskMock = URLSessionDataTaskMock(taskResponse: (data, response, error))
    }

    override func dataTaskWithURL(url: NSURL, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    override func dataTaskWithRequest(request: NSURLRequest, completionHandler: CompletionHandler) -> NSURLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    final private class URLSessionDataTaskMock: NSURLSessionDataTask {
        var completionHandler: CompletionHandler?
        var taskResponse: TaskResponse

        init(taskResponse: TaskResponse) {
            self.taskResponse = taskResponse
        }

        override func resume() {
            completionHandler?(taskResponse.data, taskResponse.response, taskResponse.error)
        }

        override func cancel() {
            // do nothing
        }

    }
    
}
