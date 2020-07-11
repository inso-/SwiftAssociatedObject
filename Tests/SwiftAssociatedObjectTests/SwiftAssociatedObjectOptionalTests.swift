import XCTest
@testable import SwiftAssociatedObject


fileprivate class TestClass: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = TestClass(value: self.value)
        return copy
    }

    var value: Int

    init(value: Int) {
        self.value = value
    }
}

fileprivate enum Style {
    case dark
    case light
    case `default`
}

fileprivate protocol Stylable {
    var style: Style { get set }
}

fileprivate protocol Zombifiable {
    var isZombified: Bool? { get set }
}

fileprivate protocol Valuable {
    var value: Int? { get set }
}

fileprivate protocol Findable {
    var isFound: Bool { get set }
}

fileprivate protocol Plantable {
    var isPlanted: Bool { get set }
}

fileprivate protocol Vampirifiable {
    var isVampirified: Bool { get set }
}

fileprivate protocol Testable {
    var testClass: TestClass { get set }
    var testCopyClass: TestClass { get set }
}

extension NSObject: Stylable {
    private var holder: AssociatedObject<Style?> {
       AssociatedObject(self, key: "Stylable")
    }
    
    fileprivate var style: Style {
        get { holder.wrappedValue ?? Style.default }
        set { holder.wrappedValue = newValue }
    }
}

extension NSObject: Zombifiable {
    private var isZombieAssociated: AssociatedObject<Bool?> {
        AssociatedObject(self, key: "isZombified")
    }
    
    public var isZombified: Bool? {
        get { isZombieAssociated.wrappedValue }
        set { isZombieAssociated.wrappedValue = newValue }
    }
}

extension NSObject: Vampirifiable {
    public var isVampirified: Bool {
        get { AssociatedObject(self, key: "isVampirified", initValue: false)() ?? true}
        set { AssociatedObject(self, key: "isVampirified")(Optional(newValue))}
    }
}

var test: Int? = 42

extension NSObject: Valuable {

    private var valueAssociated: AssociatedObject<Int?> {
        AssociatedObject(self, key: "valueAssociated",
                                 initValue: test,
                                 policy:.atomic)
    }

    public var value: Int? {
        get { valueAssociated.wrappedValue ?? nil }
        set { valueAssociated.wrappedValue = newValue }
    }
}

private var testClassGlobal = TestClass(value: 42)

extension NSObject: Testable {

    private var testAssociated: AssociatedObject<TestClass?> {
        AssociatedObject(self, key: "test", initValue: Optional(testClassGlobal), policy: .assign)
    }

    private var testCopyAssociated: AssociatedObject<TestClass?> {
        AssociatedObject(self, key: "testCopyClass",
                         initValue: Optional(testClassGlobal),
                         policy: .copy_atomic)
    }

    fileprivate var testClass: TestClass {
        get { testAssociated.wrappedValue ?? TestClass(value: 88) }
        set { testAssociated.wrappedValue = newValue }
    }

    fileprivate var testCopyClass: TestClass {
        get { (testCopyAssociated.wrappedValue ?? TestClass(value: 88)) }
        set { testCopyAssociated.wrappedValue = newValue }
    }
}

final class SwiftOptionalAssociatedObjectTests: XCTestCase {

    func testSwiftOptionalAssociatedObject(){
        func subtest() {
            let a = NSObject()
            a.style = .dark
            a.isZombified = false
            a.isVampirified = true
            a.value = 10
            a.testClass = testClassGlobal
            assert(a.testClass.value == 42)
            a.testClass.value = 33

            a.testCopyClass.value = 12
            assert(a.testClass.value == 33)
            assert(a.style == .dark)
            assert(a.isZombified == false)
            assert(a.isVampirified == true)
            assert(a.value == 10)
            a.value = nil
            assert(a.value == nil)
            assert(test == 42)
            assert(testClassGlobal.value == 33)
            assert(a.testCopyClass.value == 12)
        }
        subtest()
        let b = NSObject()

        assert(b.value == 42)
        assert(b.style == .default)
        assert(b.isZombified == nil)
        assert(b.isVampirified == false)
    }
    
    static var allTests = [
        ("testSwiftOptionalAssociatedObject",
         testSwiftOptionalAssociatedObject)
    ]
}
