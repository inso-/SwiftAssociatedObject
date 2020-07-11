# SwiftAssociatedObject
Pure Swift Implementation of Associated Object

<img src="https://www.pinclipart.com/picdir/big/318-3183886_my-swift-note-swift-programming-language-logo-clipart.png" width=100%>

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)]()
[![Issues](https://img.shields.io/github/issues/inso-/SwiftAssociatedObject.svg?style=flat)](https://github.com/inso-/SwiftAssociatedObject/issues)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-green.svg?style=flat)](https://swift.org/package-manager/)


Swift Associated Object is a pure swift implementation of Associated Object bundle in a framework for iOS, tvOS, watchOS, macOS, and Mac Catalyst.
- Swift Associated Object let you forget about the “Extensions must not contain stored properties” constraint with a pure swift approach
- It is not a wrapper on Objective-C runtime Associated Object !

## Content

- [Features](#features)
- [Add stored properties on a class extension](#add-stored-properties-on-a-class-extension)
	- [Using Associated Object](#using-associatedobject)
	- [Associated Object Policy](#associated-object-policy)
- [Requirements](#requirements)
- [Installation](#installation)
	- [Swift Package Manager](#swift-package-manager)
	- [Carthage](#carthage)
- [Apps using SwiftAssociatedObject](#apps-using-swiftassociatedobject)
- [License](#license)

## Features

- Add stored property on a class extension.
- Thread safe.
- Auto-release memory based on ARC.
- Swift Associated Object let you forget about the “Extensions must not contain stored properties” constraint 
- Pure swift approach (no dependency on Objective-C runtime).
- iOS, tvOS, watchOS, macOS, and Catalyst compatible

## Contributing

#### Got issues / pull requests / want to contribute?

You are welcome!

## Add stored properties on a class extension

### Using AssociatedObject

#### Using AssociatedObject Swift>=5.2


```swift

import SwiftAssociatedObject

protocol MyProtocol {
    var myStoredVar: Bool { get set }
}

extension NSObject: MyProtocol {
    private var myStoredVarAssociated: AssociatedObject<Bool> {
        AssociatedObject(self, key: "myStoredVar", initValue: false)
    }

    public var myStoredVar: Bool {
        get { myStoredVarAssociated() }
        set { myStoredVarAssociated(newValue) }
    }
}
```
#### Using AssociatedObject Swift>=5 
```swift

import SwiftAssociatedObject

protocol MyProtocol {
    var myStoredVar: Bool { get set }
}

extension NSObject: MyProtocol {
    private var myStoredVarAssociated: AssociatedObject<Bool> {
        AssociatedObject(self, key: "myStoredVar", initValue: false)
    }
    
    public var myStoredVar: Bool {
        get { myStoredVarAssociated.wrappedValue }
        set { myStoredVarAssociated.wrappedValue = newValue }
    }
}
```

### Associated Object Policy

You can specify an AssociatedObjectPolicy on AssociatedObject Initialization to define the association type.
If you don't define one the default .atomic Policy will be used.

```swift
 	/// Specifies a weak reference to the associated object.
    	/// Require the associated object to be an optional reference type.
    	case assign

	/// Specifies that the association is made atomically.
    	/// On a reference type the associated object will be a strong reference.
    	/// On a value type the associated object is copied.
    	case atomic

	/// Specifies that the association is not made atomically.
    	/// On a reference type the associated object will be a strong reference.
    	/// On a value type the associated object is copied.
    	case non_atomic

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

```

#### AssociatedObjectPolicy Exemple

```swift

import SwiftAssociatedObject

private var testClassGlobal = NSNumber(value: 42)

fileprivate protocol Valuable {
    var weakValue: NSNumber? { get set }
    var copiedOptionalValue: NSNumber? { get set }
}

extension NSObject: Valuable {

    private var weakValueAssociated: AssociatedObject<NSNumber?> {
        AssociatedObject(self, key: "weakValue", initValue: Optional(testClassGlobal), policy: .assign)
    }

    private var copiedOptionalAssociated: AssociatedObject<NSNumber?> {
        AssociatedObject(self, key: "copiedOptionalValue",
                         initValue: Optional(testClassGlobal),
                         policy: .copy_atomic)
    }

    fileprivate var weakValue: NSNumber? {
        get { weakValueAssociated() }
        set { weakValueAssociated(newValue) }
    }

    fileprivate var copiedOptionalValue: NSNumber? {
        get { copiedOptionalAssociated() }
        set { copiedOptionalAssociated(newValue) }
    }
}
```

#### Associated Object Policy



## Requirements

| iOS | watchOS | tvOS | macOS | Mac Catalyst |
|-----|---------|------|-------|--------------|
| 8.0 | 6.2     | 9.0  | 10.10 | 13.0         |

## Installation
There are a number of ways to install SwiftAssociatedObject for your project. Swift Package Manager and Carthage integrations are the preferred and recommended approaches. Unfortunately, CocoaPods is not supported yet.

Regardless, make sure to import the project wherever you may use it:

```swift
import SwiftAssociatedObject
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into Xcode and the Swift compiler. **This is the recommended installation method.** Updates to SwiftAssociatedObject will always be available immediately to projects with SPM. SPM is also integrated directly with Xcode.

If you are using Xcode 11 or later:
 1. Click `File`
 2. `Swift Packages`
 3. `Add Package Dependency...`
 4. Specify the git URL for SwiftAssociatedObject.

```swift
https://github.com/inso-/SwiftAssociatedObject.git
```

### Carthage

To integrate SwiftAssociatedObject into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:

```ogdl
github "inso-/SwiftAssociatedObject"
```

**NOTE**: Please ensure that you have the [latest](https://github.com/Carthage/Carthage/releases) Carthage installed.

## Apps using SwiftAssociatedObject

It would be great to showcase apps using SwiftAssociatedObject here. Pull requests welcome :)

## License

MIT License

Copyright (c) 2020 Thomas Moussajee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
