//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation
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

private class Three: NumberType {
    let value = 3
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

                let number: Onable? = try? self.injector.provide()

                expect(number?.value).to(equal(1))
            }

            it("should return last implementation of a registered type") {
                self.injector.register { One(value: 1) as Onable }
                self.injector.register { Two() as NumberType }

                let number: NumberType? = try? self.injector.provide()

                expect(number?.value).to(equal(2))
            }

            it("should return same object") {
                let three = Three()
                self.injector.register { three }

                let number: Three? = try? self.injector.provide()

                expect(number).to(beIdenticalTo(three))
            }

            it("should return last registered object") {
                self.injector.register { Three() }
                let three2 = Three()
                self.injector.register { three2 }

                let number: Three? = try? self.injector.provide()

                expect(number).to(beIdenticalTo(three2))
            }

            it("should be able to deregister object") {
                let three = Three()
                self.injector.register { three }
                self.injector.deregister(three.dynamicType)

                let number: Three? = try? self.injector.provide()

                expect(number).to(beNil())
            }

            it("should throw error if type is not registered") {
                expect { try self.injector.provide() as NumberType }.to(throwError())
            }

        }
    }

}
