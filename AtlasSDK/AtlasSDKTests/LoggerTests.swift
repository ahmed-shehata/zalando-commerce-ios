//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Nimble
@testable import AtlasSDK

class LoggerSpec: QuickSpec {

    override func spec() {

        describe("Logger extensions") {

            beforeEach {
                AtlasLogger.logger.outputStream = ""
            }

            afterEach {
                AtlasLogger.logger.outputStream = StdoutOutputStream()
            }

            let loggedMessage = "Logged message"
            var loggerOutput: String? {
                guard let output = AtlasLogger.logger.outputStream as? String else {
                    fail("No String in logger")
                    return nil
                }
                return output
            }

            it("Writes error message for Error severity") {
                AtlasLogger.logger.severity = .Error

                AtlasLogger.logError(loggedMessage)

                expect(loggerOutput).to(contain(loggedMessage))
            }

            it("Writes message for Message severity") {
                AtlasLogger.logger.severity = .Message

                AtlasLogger.logMessage(loggedMessage)

                expect(loggerOutput).to(contain(loggedMessage))
            }

            it("Skips message for Error severity") {
                AtlasLogger.logger.severity = .Error

                AtlasLogger.logMessage(loggedMessage)

                expect(loggerOutput).toNot(contain(loggedMessage))
            }

            it("Writes debug message for Debug severity") {
                AtlasLogger.logger.severity = .Debug

                AtlasLogger.logDebug(loggedMessage)

                expect(loggerOutput).to(contain(loggedMessage))
            }

            it("Skips debug message for Error severity") {
                AtlasLogger.logger.severity = .Error

                AtlasLogger.logDebug(loggedMessage)

                expect(loggerOutput).toNot(contain(loggedMessage))
            }

            it("Skips debug message for Error severity") {
                AtlasLogger.logger.severity = .Message

                AtlasLogger.logDebug(loggedMessage)

                expect(loggerOutput).toNot(contain(loggedMessage))
            }

            it("Shows name of called function and file in verbose mode") {
                AtlasLogger.logger.severity = .Debug

                AtlasLogger.logDebug(loggedMessage, verbose: true)

                expect(loggerOutput).to(contain("spec()"))
                expect(loggerOutput).to(contain("LoggerSpec.swift"))

            }

        }

    }

}
