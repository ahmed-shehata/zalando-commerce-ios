//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import AtlasSDK

private protocol NumberType {
    var value: Int { get }
}

private protocol Onable: NumberType {
    var value: Int { get }
}

private struct One: Onable {
    var value = 1
}

private struct Two: NumberType {
    let value = 2
}

class InjectorSpec: QuickSpec {

    var injector: Injector!

    override func spec() {
        describe("Injector") {

            beforeEach {
                self.injector = Injector()
            }

            it("should return implementation of a registered type") {
                self.injector.register { One(value: 1) as Onable }
                let number = try! self.injector.provide() as Onable // swiftlint:disable:this force_try
                expect(number.value).to(equal(1))
            }

            it("should return last implementation of a registered type") {
                self.injector.register { One(value: 1) as Onable }
                self.injector.register { Two() as NumberType }
                let number = try! self.injector.provide() as NumberType // swiftlint:disable:this force_try
                expect(number.value).to(equal(2))
            }

            it("should throw error if type is not registered") {
                expect { try self.injector.provide() as NumberType }.to(throwError())
            }

        }
    }

}
