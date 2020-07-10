//
//  AssociatedObject.swift
//  
//
//  Created by Thomas on 09/07/2020.
//

import Foundation

@propertyWrapper
public class AssociatedObject<T: Any>: OptionalAssociatedObject<T> {

    public override var wrappedValue: T! {
        get { AssociatedObjects.get(key, policy: policy) }
        set {
            AssociatedObjects.set(key, value: newValue as Any, policy: policy)
        }
    }

    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T,
                             policy: AssociatedObjectValuePolicy? = nil) {
        super.init(object, key: key, policy: policy)
        if wrappedValue == nil {
            wrappedValue = initValue
        }
    }

    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T,
                             policy: AssociatedObjectCopyValuePolicy)
        where T: AnyObject & NSCopying {
            super.init(object, key: key, policy: policy)
            if wrappedValue == nil {
                wrappedValue = initValue
            }
    }

    #if swift(>=5.2)

    public override func callAsFunction() -> T {
        wrappedValue
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
                             initValue: T? = nil,
                             policy: AssociatedObjectValuePolicy? = .atomic) {
        self.key = AssociatedObjectKey(object, key: key)
        switch policy {
        case .atomic, .none:
            self.policy = .atomic
        case .non_atomic:
            self.policy = .non_atomic
        }
        if !AssociatedObjects.haveKey(self.key, policy: self.policy) {
            self.wrappedValue = initValue
        }
    }


    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T? = nil,
                             policy: AssociatedObjectReferencePolicy)
        where T: AnyObject {
            self.key = AssociatedObjectKey(object, key: key)
            switch policy {
            case .assign:
                self.policy = .assign
            }
        if !AssociatedObjects.haveKey(self.key, policy: self.policy) {
            self.wrappedValue = initValue
        }
    }

    public init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T? = nil,
                             policy: AssociatedObjectCopyValuePolicy)
        where T: AnyObject & NSCopying {
            self.key = AssociatedObjectKey(object, key: key)
            switch policy {
            case .copy_atomic:
                self.policy = .copy_atomic
            case .copy_non_atomic:
                self.policy = .copy_non_atomic
            }
        if !AssociatedObjects.haveKey(self.key, policy: self.policy) {
            self.wrappedValue = initValue
        }
    }


    #if swift(>=5.2)

    public func callAsFunction() -> T? {
        return wrappedValue
    }

    public func callAsFunction(_ newValue: T) -> Void {
        wrappedValue = newValue
    }

    #endif
}

#if swift(>=5.2)

enum OptionalAssociatedObjectError: Error {
    case getUnitializedValue
}

#endif

internal enum AssociatedObjectPolicy {

    /// Specifies a weak reference to the associated object.
    case assign

    /// Specifies that the associated object is copied.
    /// And that the association is made atomically.
    case copy_atomic

    /// Specifies that the associated object is copied.
    /// And that the association is not made atomically.
    case copy_non_atomic

    /// Specifies that the association is made atomically.
    case atomic

    /// Specifies that the association is not made atomically.
    case non_atomic

    internal var isAtomic: Bool {
        self == .copy_atomic || self == .atomic || self == .assign
    }

    internal var isCopy: Bool {
        self == .copy_atomic || self == .copy_non_atomic
    }
}

public enum AssociatedObjectReferencePolicy {

    /// Specifies a weak reference to the associated object.
    /// Require the associated object to be an optional reference type
    case assign

}

public enum AssociatedObjectValuePolicy {

    /// Specifies that the association is made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case atomic

    /// Specifies that the association is not made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case non_atomic
}

public enum AssociatedObjectCopyValuePolicy {

    /// Specifies that the associated object is copied.
    /// And that the association is made atomically.
    /// Require the associated object to be reference type
    /// and to conform to NSCopying protocol.
    case copy_atomic

    /// Specifies that the associated object is copied.
    /// And that the association is not made atomically.
    /// Require the associated object to be reference type
    /// and to conform to NSCopying protocol.
    case copy_non_atomic
}
