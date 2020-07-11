//
//  AssociatedObjectPolicy+Internal.swift
//  
//
//  Created by Thomas on 11/07/2020.
//

import Foundation

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

extension AssociatedObjectReferencePolicy: RealPolicy {
    internal var rPolicy: AssociatedObjectPolicy { .assign }
}

extension AssociatedObjectValuePolicy: RealPolicy {
    internal var rPolicy: AssociatedObjectPolicy {
        self == .atomic ? .atomic : .non_atomic
    }
}

extension AssociatedObjectCopyValuePolicy: RealPolicy {
    internal var rPolicy: AssociatedObjectPolicy {
        self == .copy_atomic ? .copy_atomic : .copy_non_atomic
    }
}
