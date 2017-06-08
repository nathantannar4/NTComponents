<img src="NTComponents/Assets/NT Components Banner.jpg">

[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/NTComponents.svg?style=flat)](https://cocoapods.org/pods/NTUIKit)
[![Build Status][travis-image]][travis-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NTComponents.svg)](https://img.shields.io/cocoapods/v/NTComponents.svg)   [![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/NTUIKit.svg)]()
<br>

I faced an ongoing problem of always having to set the tint color, font choice and general defaults for every project. To solve this I made `NTComponents`. A set of classes that will inherit defaults defined in `AppDelegate`. This grew into also adding useful extensions, models and custom views simplify app creation while maintaining great UI/UX.

## Features

* Maintain consistency and style with ease
    * Set global app defaults, such as color or font, that will be defaults in all NTComponent classes
* New base class controllers to work with
* Material color palette built in
* Ripple effect for buttons and views available
* Common icons built in
* Programatic auto layout
* Many useful extensions

## Requirements

- iOS 9.1+
- Xcode 8.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `NTComponents` by adding it to your `Podfile`:

```ruby
platform :ios, '9.1'
use_frameworks!
pod 'NTComponents'
```

Now, rather than importing UIKit use the following

``` swift
import NTComponents
```
#### Manually
1. Download and open ```NTComponents.xcproject```
2. Build the framework
2. Copy the NTComponents.framework product to your project

## Release History

* 0.0.5
    * Bug Fixes & Tweaks, introduction of NTFormViewController to easily make forms
* 0.0.4
    * Focus on animations and alert view updates
* 0.0.3
    * Focus on bug fixes and optimizations
* 0.0.2
    * Completed the majority of main components
* 0.0.1
    * Branch from NTUIKit

## Getting Started
I would recommend taking a look at the sample code that generates the `NTComponents Demo` app. Also try taking a look at the Jazzy generated Docs! While they are not complete yet I plan to work on documentation.

``` swift
import NTComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Set color defaults
        Color.Default.setPrimary(to: .white)
        Color.Default.setSecondary(to: .red)
        Color.Default.Text.Title = .blue

        // If you want the shadow to be more standard
        Color.Default.setCleanShadow()
        
        // Set your font defaults
        Font.Default.Title = Font.Roboto.Medium.withSize(15)
        Font.Default.Subtitle = Font.Roboto.Regular
        Font.Default.Body = Font.Roboto.Regular.withSize(13)
        
        return true
    }

    // More standard AppDelegate methods
}

```
More Coming Soon

## Planned Improvements/Additons
* NTCollectionViewCell
    * More base cells
* More useful controllers
* Camera controller
* More docs

## Contribute

We would love for you to contribute to `NTComponents` with more useful extensions, models or UI classes. If interested please contact myself.

## Author

<img src="NTComponents/Assets/Nathan.png" width="75" height="75">
Nathan Tannar - https://nathantannar.me

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/nathantannar4/NTComponents](https://github.com/nathantannar4/NTComponents)

[swift-image]:https://img.shields.io/badge/swift-3.1-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
