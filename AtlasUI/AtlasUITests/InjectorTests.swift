//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import XCTest
import Foundation
import Nimble

@testable import AtlasUI

private protocol Number {
    var value: Int { get }
}

private protocol Onable: Number {
    var value: Int { get }
}

private struct One: Onable {
    var value = 1
}

private struct Two: Number {
    let value = 2
}

private class Three: Number {
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
        injector.register { One(value: 1) as Number }
        injector.register { Two() as Number }

        let number: Number? = try? injector.provide()
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

        injector.deregister(type(of: three))

        let nilNumber: Three? = try? injector.provide()
        expect(nilNumber).to(beNil())
    }

    func testThrowErrorIfTypeNotFound() {
        expect { try self.injector.provide() as Number }.to(throwError())
    }

}
