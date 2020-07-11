//
//  AssociatedObject.swift
//  
//
//  Created by Thomas on 09/07/2020.
//

import Foundation

@propertyWrapper
public class AssociatedObject<T: Any> {

    internal let key: AssociatedObjectKey<AnyObject>
    internal var policy: AssociatedObjectPolicy

    public typealias ObjectType = T
    public typealias CopyPolicy = AssociatedObjectCopyValuePolicy
    public typealias ValuePolicy = AssociatedObjectValuePolicy
    public typealias ReferencePolicy = AssociatedObjectReferencePolicy


    public var wrappedValue: ObjectType! {
        get {
            AssociatedObjects.get(key, policy: policy) }
        set {
            AssociatedObjects.set(key, value: newValue as Any,
                                  policy: policy)
        }
    }

    required internal init<M: Hashable>(_ object: AnyObject,
                                        key: M,
                                        initValue: T,
                                        policy: AssociatedObjectPolicy,
                                        internal: Bool) {
        self.key = AssociatedObjectKey(object, key: key)
        self.policy = policy
        if !AssociatedObjects.haveKey(self.key, policy: self.policy) {
            self.wrappedValue = initValue
        }
    }

    convenience private init<M: Hashable>(_ object: AnyObject,
                                          key: M,
                                          initValue: T,
                                          policy: RealPolicy,
                                          internal: Bool) {
        self.init(object, key: key,
                  initValue: initValue,
                  policy: policy.rPolicy,
                  internal: true)
    }

    public convenience init<M: Hashable>(_ object: AnyObject,
                                         key: M,
                                         initValue: T,
                                         policy: ValuePolicy = .atomic) {
        self.init(object, key: key,
                  initValue: initValue,
                  policy: policy,
                  internal: true)
        if wrappedValue == nil {
            wrappedValue = initValue
        }
    }



    public convenience init<M: Hashable>(_ object: AnyObject,
                                         key: M,
                                         initValue: T,
                                         policy: ValuePolicy)
        where T: AnyObject & NSCopying {
            self.init(object, key: key,
                      initValue: initValue,
                      policy: policy,
                      internal: true)
            if wrappedValue == nil {
                wrappedValue = initValue
            }
    }

    public convenience init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T? = nil,
                             policy: ValuePolicy = .atomic)
        where T: OptionalType {
            self.init(object, key: key,
                      initValue: initValue.asOptional ?? nil,
                      policy: policy,
                      internal: true)
    }


    public convenience init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T = nil,
                             policy: ReferencePolicy)
        where T: OptionalType, T.WrappedType: AnyObject {
            self.init(object, key: key,
            initValue: initValue.asOptional as? ObjectType ?? nil,
            policy:policy,
            internal: true)
    }

    public convenience init<M: Hashable>(_ object: AnyObject,
                             key: M,
                             initValue: T = nil,
                             policy: CopyPolicy)
        where T: OptionalType, T.WrappedType: AnyObject & NSCopying {
            self.init(object, key: key,
                      initValue: initValue.asOptional as? ObjectType ?? nil,
                      policy:policy,
                      internal: true)
    }

    #if swift(>=5.2)

    public func callAsFunction() -> T {
        wrappedValue
    }

    public func callAsFunction(_ newValue: T) -> Void {
        wrappedValue = newValue
    }

    #endif
}

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

internal protocol RealPolicy {
    var rPolicy: AssociatedObjectPolicy { get }
}

public enum AssociatedObjectReferencePolicy: RealPolicy {

    /// Specifies a weak reference to the associated object.
    /// Require the associated object to be an optional reference type
    case assign

    internal var rPolicy: AssociatedObjectPolicy {
        .assign
    }
}

public enum AssociatedObjectValuePolicy: RealPolicy {

    /// Specifies that the association is made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case atomic

    /// Specifies that the association is not made atomically.
    /// On a reference type the associated object will be a strong reference.
    /// On a value type the associated object is copid.
    case non_atomic

    internal var rPolicy: AssociatedObjectPolicy {
        self == .atomic ? .atomic : .non_atomic
    }
}

public enum AssociatedObjectCopyValuePolicy: RealPolicy {

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

    internal var rPolicy: AssociatedObjectPolicy {
        self == .copy_atomic ? .copy_atomic : .copy_non_atomic
    }
}
