//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Nimble

@testable import AtlasSDK

class LoggerTests: XCTestCase {

    let loggedMessage = "Logged message"
    var loggerOutput: String? {
        guard let output = AtlasLogger.logger.outputStream as? String else {
            fail("No String in logger")
            return nil
        }
        return output
    }

    override func setUp() {
        super.setUp()
        AtlasLogger.logger.outputStream = ""
    }

    override func tearDown() {
        super.tearDown()
        AtlasLogger.logger.outputStream = StdoutOutputStream()
    }

    func testErrorForErrorSeverity() {
        AtlasLogger.logger.severity = .error
        AtlasLogger.logError(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForMessageSeverity() {
        AtlasLogger.logger.severity = .message
        AtlasLogger.logMessage(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testDebugForDebugSeverity() {
        AtlasLogger.logger.severity = .debug
        AtlasLogger.logDebug(loggedMessage)
        expect(self.loggerOutput).to(contain(loggedMessage))
    }

    func testMessageForErrorSeverity() {
        AtlasLogger.logger.severity = .error
        AtlasLogger.logMessage(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForErrorSeverity() {
        AtlasLogger.logger.severity = .error
        AtlasLogger.logDebug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testDebugForMessageSeverity() {
        AtlasLogger.logger.severity = .message
        AtlasLogger.logDebug(loggedMessage)
        expect(self.loggerOutput).toNot(contain(loggedMessage))
    }

    func testFunctionNameAndFile() {
        AtlasLogger.logger.severity = .debug
        AtlasLogger.logDebug(loggedMessage, verbose: true)

        expect(self.loggerOutput).to(contain("testFunctionNameAndFile()"))
        expect(self.loggerOutput).to(contain("LoggerTests.swift"))
    }

}
