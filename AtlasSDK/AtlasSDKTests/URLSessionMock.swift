//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

typealias CompletionHandler = (Data?, URLResponse?, NSError?) -> Void
typealias TaskResponse = (data: Data?, response: URLResponse?, error: NSError?)

final class URLSessionMock: URLSession {

    var url: URL?
    var request: URLRequest?
    fileprivate let dataTaskMock: URLSessionDataTaskMock

    init(data: Data?, response: URLResponse?, error: NSError?) {
        dataTaskMock = URLSessionDataTaskMock(taskResponse: (data, response, error))
    }

    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    final fileprivate class URLSessionDataTaskMock: URLSessionDataTask {
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
