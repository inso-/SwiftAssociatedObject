//
//  AssociatedObject.swift
//  
//
//  Created by Thomas on 09/07/2020.
//

import Foundation

public protocol AssociatedObjectOptionalType: ExpressibleByNilLiteral {
    associatedtype WrappedType
    var asOptional: WrappedType? { get }
}

extension Optional: AssociatedObjectOptionalType {
    public var asOptional: Wrapped? {
        return self
    }
}

@propertyWrapper
public class AssociatedObject<T: Any> {

    internal let key: AssociatedObjectKey<AnyObject>
    internal var policy: AssociatedObjectPolicy

    public typealias ObjectType = T
    public typealias CopyPolicy = AssociatedObjectCopyValuePolicy
    public typealias ValuePolicy = AssociatedObjectValuePolicy
    public typealias ReferencePolicy = AssociatedObjectReferencePolicy
    public typealias OptionalType = AssociatedObjectOptionalType


    public var wrappedValue: ObjectType! {
        get {
            AssociatedObjects.get(key, policy: policy) }
        set {
            AssociatedObjects.set(key, value: newValue as Any,
                                  policy: policy)
        }
    }

    internal required init<M: Hashable>(_ object: AnyObject,
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

    private convenience init<M: Hashable>(_ object: AnyObject,
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
