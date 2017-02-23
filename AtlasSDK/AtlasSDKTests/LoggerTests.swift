//
//  Copyright © 2016-2017 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class LoggerTests: XCTestCase {

    let loggedMessage = "Logged message"
    var loggerOutput: String? {
        guard let output = Logger.logger.outputStream as? String else {
            fail("No String in logger")
            return nil
        }
        return output
    }

    override func setUp() {
        super.setUp()
        Logger.logger.outputStream = ""
    }

    override func tearDown() {
        super.tearDown()
        Logger.logger.outputStream = StdoutOutputStream()
    }

    func testErrorForErrorSeverity() {
        Logger.logger.severity = .error
        Logger.error(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForMessageSeverity() {
        Logger.logger.severity = .message
        Logger.message(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testDebugForDebugSeverity() {
        Logger.logger.severity = .debug
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForErrorSeverity() {
        Logger.logger.severity = .error
        Logger.message(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForErrorSeverity() {
        Logger.logger.severity = .error
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForMessageSeverity() {
        Logger.logger.severity = .message
        Logger.debug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testFunctionNameAndFile() {
        Logger.logger.severity = .debug
        Logger.debug(loggedMessage, verbose: true)

        expect(self.loggerOutput).to(contain("testFunctionNameAndFile()"))
        expect(self.loggerOutput).to(contain("LoggerTests.swift"))
    }

}
