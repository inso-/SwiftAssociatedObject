//
//  AssociatedObjectPolicy.swift
//  
//
//  Created by Thomas on 11/07/2020.
//

import Foundation

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
