import XCTest
@testable import SwiftAssociatedObject


fileprivate class Test {

}

fileprivate protocol Findable {
    var isFound: Bool { get set }
}

fileprivate protocol Plantable {
    var isPlanted: Bool { get set }
}

fileprivate protocol Testable {
    var test: Test { get set }
}

extension NSObject: Findable {
    private var isFoundAssociated: AssociatedObject<Bool> {
        AssociatedObject(self, key: "isFound",
                         initValue: false, policy: .non_atomic)
    }

    #if swift(>=5.2)

    public var isFound: Bool {
        get { isFoundAssociated() }
        set { isFoundAssociated(newValue) }
    }

    #else

    public var isFound: Bool {
        get { isFoundAssociated.wrappedValue }
        set { isFoundAssociated.wrappedValue = newValue }
    }

    #endif
}

extension NSObject: Plantable {
    private var isPlantedAssociated: AssociatedObject<Bool> {
        AssociatedObject(self, key: "isPlanted", initValue: false)
    }
    
    #if swift(>=5.2)
    
    public var isPlanted: Bool {
        get { isPlantedAssociated() }
        set { isPlantedAssociated(newValue) }
    }
    
    #else
    
    public var isPlanted: Bool {
        get { isPlantedAssociated.wrappedValue }
        set { isPlantedAssociated.wrappedValue = newValue }
    }
    
    #endif
}

extension NSObject: Testable {
    private var testAssociated: AssociatedObject<Test> {
        AssociatedObject(self, key: "Testable",
                         initValue: Test(),
                         policy: .atomic)
    }

    fileprivate var test: Test {
        get {
            testAssociated.wrappedValue
        }
        set {
            testAssociated.wrappedValue = newValue
        }
    }
}


final class SwiftAssociatedObjectTests: XCTestCase {
    func testSwiftAssociatedObject() {
        func subtest() {
            let a = NSObject()
            a.isPlanted = true

            assert(a.isPlanted == true)
        }
        subtest()
        let b = NSObject()

        assert(b.isPlanted == false)
    }

    func testSwiftAssociatedObjectNonAtomic() {
        func subtest() {
            let a = NSObject()
            a.isPlanted = true

            assert(a.isPlanted == true)
        }
        subtest()
        let b = NSObject()

        assert(b.isPlanted == false)
    }
    
    static var allTests = [
        ("testSwiftAssociatedObject",
         testSwiftAssociatedObject),
        ("testSwiftAssociatedObjectNonAtomic",
         testSwiftAssociatedObjectNonAtomic),
    ]
}
