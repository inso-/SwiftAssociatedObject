//
//  AssociatedObject.swift
//  
//
//  Created by Thomas on 09/07/2020.
//

import Foundation

@propertyWrapper
public class AssociatedObject<T: Any>: OptionalAssociatedObject<T> {

    private var `default`: T

    public override var wrappedValue: T? {
        get { AssociatedObjects.get(key, policy: policy) ?? self.default }
        set {
            AssociatedObjects.set(key, value: newValue as Any, policy: policy)
        }
    }

    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             defaultValue: T,
                             policy: AssociatedObjectPolicy? = nil) {
        self.default = defaultValue
        super.init(object, key: key)
    }

    #if swift(>=5.2)

    override func callAsFunction() -> T {
        wrappedValue ?? self.default
    }

    #endif
}

@propertyWrapper
public class OptionalAssociatedObject<T: Any> {

    public var wrappedValue: T? {
        get { AssociatedObjects.get(key, policy: policy) ?? nil }
        set {
            AssociatedObjects.set(key, value: newValue as Any, policy: policy)
        }
    }

    internal let key: AssociatedObjectKey<AnyObject>
    internal var policy: AssociatedObjectPolicy

    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             policy: AssociatedObjectPolicy = .atomic) {
        self.key = AssociatedObjectKey(object, key: key)
        if T.self is AnyClass {
            self.policy = policy
        } else {
            switch policy {
            case .atomic, .copy_atomic, .assign:
                self.policy = .copy_atomic
            case .non_atomic, .copy_non_atomic:
                self.policy = .copy_non_atomic
            }
        }
    }

    deinit {
        AssociatedObjects.remove()
    }

    #if swift(>=5.2)

    func callAsFunction() -> T? {
        return wrappedValue
    }

    func callAsFunction() throws -> T {
        if let v = wrappedValue {
            return v
        }
        throw OptionalAssociatedObjectError.getUnitializedValue
    }

    func callAsFunction(_ newValue: T) -> Void {
        wrappedValue = newValue
    }

    #endif
}

#if swift(>=5.2)

enum OptionalAssociatedObjectError: Error {
    case getUnitializedValue
}

#endif

public enum AssociatedObjectPolicy {

    /// Specifies a weak reference to the associated object.
    /// Require the associated object to be a reference type,
    case assign

    /// Specifies that the associated object is copied.
    /// And that the association is made atomically.
    /// Require the associated object to be a value type,
    /// or to conform to NSCopying protocol.
    case copy_atomic

    /// Specifies that the associated object is copied.
    /// And that the association is not made atomically.
    /// Require the associated object to be a value type,
    /// or to conform to NSCopying protocol.
    case copy_non_atomic

    /// Specifies that the association is made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case atomic

    /// Specifies that the association is not made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case non_atomic

    internal var isAtomic: Bool {
        self == .copy_atomic || self == .atomic
    }

    internal var isCopy: Bool {
        self == .copy_atomic || self == .copy_non_atomic
    }
}
