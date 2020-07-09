import XCTest
@testable import SwiftAssociatedObject


public enum Style {
    case dark
    case light
    case `default`
}

protocol Stylable {
    var style: Style { get set }
}

protocol Zombifiable {
    var isZombified: Bool? { get set }
}

protocol Plantable {
    var isPlanted: Bool { get set }
}

protocol Vampirifiable {
    var isVampirified: Bool { get set }
}

extension NSObject: Stylable {
    private func holder<T>() -> OptionalAssociatedObject<T> {
        OptionalAssociatedObject(self, key: "Stylable")
    }
    
    public var style: Style {
        get { holder().wrappedValue ?? Style.default }
        set { holder().wrappedValue = newValue }
    }
}

extension NSObject: Zombifiable {
    private var isZombieAssociated: OptionalAssociatedObject<Bool> {
        OptionalAssociatedObject(self, key: "isZombified")
    }
    
    public var isZombified: Bool? {
        get { isZombieAssociated.wrappedValue }
        set { isZombieAssociated.wrappedValue = newValue }
    }
}

extension NSObject: Plantable {
    private var isPlantedAssociated: AssociatedObject<Bool> {
        AssociatedObject(self, key: "isPlanted", defaultValue: false)
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

extension NSObject: Vampirifiable {
    public var isVampirified: Bool {
        get {
            do { return try OptionalAssociatedObject(self,
                                                     key: "isVampirified")() }
            catch { debugPrint(error); return false }
        }
        set { OptionalAssociatedObject(self, key: "isVampirified")(newValue)}
    }
}

final class SwiftAssociatedObjectTests: XCTestCase {
    func testSwiftAssociatedObject() {
        func subtest() {
            let a = NSObject()
            a.style = .dark
            a.isPlanted = true
            a.isZombified = false
            a.isVampirified = true
            
            assert(a.style == .dark)
            assert(a.isPlanted == true)
            assert(a.isZombified == false)
            assert(a.isVampirified == true)
        }
        subtest()
        let b = NSObject()
        
        assert(b.style == .default)
        assert(b.isPlanted == false)
        assert(b.isZombified == nil)
        assert(b.isVampirified == false)
    }
    
    static var allTests = [
        ("testSwiftAssociatedObject", testSwiftAssociatedObject),
    ]
}
