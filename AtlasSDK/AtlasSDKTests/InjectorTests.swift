//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
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

class InjectorTests: XCTestCase {

    var injector: Injector!

    override func setUp() {
        super.setUp()

        injector = Injector()
    }

    func testRegisterTypeOneTime() {
        injector.register { One(value: 1) as Onable }
        let number: Onable? = try? injector.provide()

        expect(number?.value).to(equal(1))
    }

    func testRegisterTypeManyTimes() {
        injector.register { One(value: 1) as NumberType }
        injector.register { Two() as NumberType }

        let number: NumberType? = try? injector.provide()
        expect(number?.value).to(equal(2))
    }

    func testRetrieveIdenticalObject() {
        let three = Three()
        injector.register { three }

        let number: Three? = try? injector.provide()
        expect(number).to(beIdenticalTo(three))
    }

    func testRetrieveLastIdenticalObject() {
        injector.register { Three() }
        let three2 = Three()
        injector.register { three2 }

        let number: Three? = try? injector.provide()
        expect(number).to(beIdenticalTo(three2))
    }

    func testDeregisterObject() {
        let three = Three()
        injector.register { three }

        let number: Three? = try? injector.provide()
        expect(number).toNot(beNil())

        injector.deregister(three.dynamicType)

        let nilNumber: Three? = try? injector.provide()
        expect(nilNumber).to(beNil())
    }

    func testThrowErrorIfTypeNotFound() {
        expect { try self.injector.provide() as NumberType }.to(throwError())
    }

}
