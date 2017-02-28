//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class LoggerTests: XCTestCase {

    let loggedMessage = "Logged message"
    var loggerOutput: String? {
        guard let output = Logger.output.outputStream as? String else {
            fail("No String in logger")
            return nil
        }
        return output
    }

    override func setUp() {
        super.setUp()
        Logger.output.outputStream = ""
    }

    override func tearDown() {
        super.tearDown()
        Logger.output.outputStream = StdoutOutputStream()
    }

    func testErrorForErrorSeverity() {
        Logger.output.severity = .error
        Logger.error(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForMessageSeverity() {
        Logger.output.severity = .message
        Logger.message(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testDebugForDebugSeverity() {
        Logger.output.severity = .debug
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForErrorSeverity() {
        Logger.output.severity = .error
        Logger.message(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForErrorSeverity() {
        Logger.output.severity = .error
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForMessageSeverity() {
        Logger.output.severity = .message
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testFunctionNameAndFile() {
        Logger.output.severity = .debug
        Logger.debug(loggedMessage, verbose: true)

        expect(self.loggerOutput).to(contain("testFunctionNameAndFile()"))
        expect(self.loggerOutput).to(contain("LoggerTests.swift"))
    }

}
