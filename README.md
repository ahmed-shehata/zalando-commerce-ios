[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zalando-incubator/atlas-ios/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/AtlasSDK.svg?maxAge=3600)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/AtlasSDK.svg?maxAge=3600)]()
[![CocoaPods](https://img.shields.io/cocoapods/at/AtlasSDK.svg?maxAge=3600)]()

[![Build Status](https://travis-ci.org/zalando-incubator/atlas-ios.svg?branch=master)](https://travis-ci.org/zalando-incubator/atlas-ios)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=57a305cb34a9450100595b71&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/57a305cb34a9450100595b71/build/latest)
[![codecov](https://codecov.io/gh/zalando-incubator/atlas-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/zalando-incubator/atlas-ios)
[![codebeat badge](https://codebeat.co/badges/85202868-c550-46c0-9423-f71467f0fabf)](https://codebeat.co/projects/github-com-zalando-incubator-atlas-ios)

# Atlas iOS SDK

Atlas iOS SDK for Zalando Checkout and Catalog APIs.

The purpose of this project is to provide seamless experience of Zalando
articles checkout integration to the 3rd party iOS app in few minue

Our goal is to allow iOS developer integrate and run Zalando checkout in
minutes using a few lines of code.

The project consists of 2 frameworks:

* __AtlasSDK__ – provides all low-level calls to API backend and response models,
and allows to implement own UI solution
* __AtlasUI__ – provides end-to-end UI implementation of Checkout process,
which could be used with a single fire-and-forget call.

## Installation

### Cocoapods

### Carthage

1. Add Atlas SDK to your `Cartfile.private`:
	```
	github "zalando-incubator/atlas-ios"
	```
1. Run `carthage update --platform iOS`
1. From your `Carthage/Build/iOS/` directory, add `AtlasSDK` and `AtlasUI` to your "Embedded Binaries":
![Embedded Binaries](Documentation/installation/carthage-embed.png)

## Configuration

1. Configure Atlas SDK first in the AppDelegate:

    ```swift
    import AtlasSDK

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
       func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            AtlasSDK.configure(Options(clientId: "CLIENT_ID", salesChannel: "SALES_CHANNEL_ID"))
            return true
        }
    }
    ```

2. Start checkout somewhere in your view controller, e.g. when a user tap on a buy button:

    ```swift
    import UIKit
    import AtlasCheckout

    class ViewController: UIViewController {
        @IBAction private func buyButtonTapped(sender: UIButton) {
            let sku = "sku-123"
            AtlasCheckout.presentCheckout(sku: sku)
        }
    }
    ```

3. No third step :)


## Atlas SDK Structure

1. Provides main entry point for basic functions for Atlas SDK
1. Keeps entities used in all sub-projects.
1. Doesn't contain UI related calls

![structure](Documentation/AtlasSDK Structure.png)

### Commons

Contains all the generic methods used internally within Atlas SDK. Think about it as Cocoa Touch Foundation.

### Commons UI

Contains all the generic UI methods used internally within Atlas SDK. Think about it as Cocoa Touch UIKit.

### API Client

Provides all API network calls. Shouldn't be used externally.

### Models

Contains all public models used for API calls.

### Checkout

Public Checkout functionality provided to customers.

## LICENSE

The MIT License (MIT) Copyright © 2016 Zalando SE, https://tech.zalando.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the “Software”), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
