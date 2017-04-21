# NTComponents
> Everything you need to build amazing iOS apps

[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/NTUIKit.svg?style=flat)](https://cocoapods.org/pods/NTUIKit)
[![Build Status][travis-image]][travis-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NTUIKit.svg)](https://img.shields.io/cocoapods/v/NTUIKit.svg)   [![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/NTUIKit.svg)]()


I faced an ongoing problem of always having to set the tint color, font choice and general for every subclass I made of UIKit. To solve this I made `NTComponents`. A set of classes that will inherit defaults defined in `AppDelegate`. This grew into also adding useful extensions, models and custom views simplify app creation while maintaining great UI/UX.

## Features

* MAintain consistency and style with ease
    * Set global app defaults, such as color or font, that will be defaults in all NTComponent classes
* Material color palette built in
* Roboto font build in
* Ripple effect for buttons and views available
* Common icons built in
* Programatic auto layout
* Many useful extensions

## Requirements

- iOS 9.1+
- Xcode 8.0

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `NTComponents` by adding it to your `Podfile`:

```ruby
platform :ios, '9.1'
use_frameworks!
pod 'NTComponents'
```

To get the full benefits import `NTComponents` wherever you import UIKit

``` swift
import NTComponents
```
#### Manually
1. Download and drop ```NTComponents.xcproject``` in your project.  
2. Link the NTComponents.framework product to your projects binaries

## Release History

* 0.0.1
    * Work in progress

## Contribute

We would love for you to contribute to **NTComponents** with more useful extensions, models or UI classes. If interested please contact myself.

## Meta

[Nathan Tannar](https://nathantannar.me)  – nathantannar4@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/nathantannar4/NTComponents](https://github.com/nathantannar4/NTComponents)

[swift-image]:https://img.shields.io/badge/swift-3.1-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
