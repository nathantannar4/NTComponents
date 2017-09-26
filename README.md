<img src="https://github.com/nathantannar4/NTComponents/raw/master/NTComponents/Assets/NT%20Components%20Banner.jpg">

[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/NTComponents.svg?style=flat)](https://cocoapods.org/pods/NTUIKit)
[![Build Status][travis-image]][travis-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NTComponents.svg)](https://img.shields.io/cocoapods/v/NTComponents.svg)   [![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/NTComponents.svg)]()
<br>

For the better part of two years I have been learning Swift. During this time I used a lot of 3rd party dependencies to build out my apps. While they were useful for getting started, I wanted to dive deeper and create my own set of components that would have the essentials I would need to develop apps moving forward.

I faced an ongoing problem of always having to set the tint color, font choice and general defaults for every project. To solve this I made `NTComponents`. A set of classes that will inherit defaults defined in `AppDelegate`. This grew into also adding useful extensions, models and custom views simplify app creation while maintaining great UI/UX.

Hit that star button to show your support!

## Features

* Maintain consistency and style with ease
    * Set global app defaults, such as color or font, that will be defaults in all NTComponent classes
* Custom container controllers
    * NTDrawerController, NTScrollableTabBarController and more!
* Material color palette available
* FontAwesome and GoogleMaterialDesign icons available
* Material ripple effect for buttons and views available
* Programatic auto layout
* Many useful extensions (seriously take a look!)

## Documentation
While NTComponents has yet to be fully documented, you can find the docs here: https://nathantannar.me/NTComponents/docs/

## Requirements

- iOS 9.1+
- Xcode 9.0+
- Swift 4

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
* 1.0.0
    * Swift 4
* 0.0.7
    * More views, bug fixes and optimizations
* 0.0.6
    * Added calendar view integration from JTAppleCalendar and an all new NTDrawerController
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
I would recommend taking a look at the sample code that generates the `NTComponents Demo` app. Also try taking a look at the Jazzy generated Docs(https://nathantannar.me/NTComponents/docs/)! While they are not complete yet I plan to work on documentation.

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
## Screen Captures

###### Onboarding

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/Onboarding1.png" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/Onboarding2.png" width="242" height="432">

###### Login

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTLoginViewController.png" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTEmailAuthViewController.png" width="242" height="432">

###### Alerts

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTActionSheetController.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTAlertViewController.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTChime.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTPing.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTActivityViews.gif" width="242" height="432">

###### Controller Containers

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTDrawerController.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTScrollableTabBarController.gif" width="242" height="432">

###### Forms

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTFormController.gif" width="242" height="432">

###### And Much, Much, More

<img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTMagicView.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/Colors.gif" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTCalendarViewController.png" width="242" height="432"> <img src="https://github.com/nathantannar4/NTComponents/raw/master/Screenshots/NTTimelineCell.png" width="242" height="432">


## Planned Improvements/Additons
* NTCollectionViewCell
    * More base cells
* Camera controller
* More docs

## Contribute

We would love for you to contribute to `NTComponents` with more useful extensions, models or UI classes. If interested please contact myself.

## Bugs

Find a bug? Please feel free to let me know!

## Author

<img src="https://github.com/nathantannar4/NTComponents/raw/master/NTComponents/Assets/Nathan.png" width="75" height="75">
Nathan Tannar - https://nathantannar.me

## Acknowledgements

I would like to thank the following open source developers. Some of which I either drew inspiration upon or reworked their code into `NTComponents`

Brian Voong - https://github.com/bhlvoong/LBTAComponents
Raul Riera - https://github.com/raulriera/TextFieldEffects
patchthecode - https://github.com/patchthecode/JTAppleCalendar
Zheng-Xiang Ke - https://github.com/kf99916/TimelineTableViewCell
Ryo Aoyama - https://github.com/ra1028/Former
Amornchai Kanokpullwad - https://github.com/zoonooz/ZFRippleButton

And to all of the contributors on StackOverflow

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/nathantannar4/NTComponents](https://github.com/nathantannar4/NTComponents)

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
