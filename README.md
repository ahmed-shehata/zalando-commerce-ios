[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zalando-incubator/atlas-ios/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/AtlasSDK.svg?maxAge=3600)](http://cocoadocs.org/docsets/AtlasSDK)
[![CocoaPods](https://img.shields.io/cocoapods/p/AtlasSDK.svg?maxAge=3600)](http://cocoadocs.org/docsets/AtlasSDK)
[![CocoaPods](https://img.shields.io/cocoapods/at/AtlasSDK.svg?maxAge=3600)](http://cocoadocs.org/docsets/AtlasSDK)
[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=57a305cb34a9450100595b71&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/57a305cb34a9450100595b71/build/latest)
[![codecov](https://codecov.io/gh/zalando-incubator/atlas-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/zalando-incubator/atlas-ios)
[![codebeat badge](https://codebeat.co/badges/85202868-c550-46c0-9423-f71467f0fabf)](https://codebeat.co/projects/github-com-zalando-incubator-atlas-ios)

# Atlas iOS SDK

Atlas iOS SDK for Zalando Checkout and Catalog APIs.

The purpose of this project is to provide seamless experience of Zalando
articles checkout integration to the 3rd party iOS app in few minutes.

Our goal is to allow iOS developer integrate and run Zalando Сheckout in
minutes using a few lines of code.

The project consists of 2 frameworks:

* __AtlasSDK__ – provides all low-level calls to API backend and response models,
and allows to implement own UI solution
* __AtlasUI__ – provides end-to-end UI implementation of Checkout process,
which could be used with a single fire-and-forget call.

## Installation

### Cocoapods

```
use_frameworks!

pod 'AtlasSDK'
```

### Carthage

1. Add Atlas SDK to your `Cartfile.private`:
	```
	github "zalando-incubator/atlas-ios"
	```
1. Run `carthage update --platform iOS`
1. From your `Carthage/Build/iOS/` directory, add `AtlasSDK` and `AtlasUI` to your "Embedded Binaries":
![Embedded Binaries](https://raw.githubusercontent.com/zalando-incubator/atlas-ios/master/Documentation/carthage-embed.png)

### Manually
1. Drag AtlasSDK.xcodeproj and AtlasUI.xcodeproj to your project in the __Project Navigator__.
1. Select your project, your app target, and open the __Build Phases__ panel.
1. Open the __Target Dependencies__ group, and add AtlasSDK.framework and AtlasUI.framework.
1. Click on the __+__ button at the top left of the panel and select __New Copy Files Phase__. Set Destination to __Frameworks__, and add AtlasSDK.framework and AtlasUI.framework.
1. Import AtlasSDK and AtlasUI where you use AtlasSDK.

## Configuration

You need to configure Atlas SDK first and use configured instance variable to interact with AtlasSDK.

### Manual configuration

In order to configure AtlasCheckout manually create an `Options` instance with at least 2 mandatory parameters `clientId` and `salesChannel`:

```swift
import AtlasSDK
import AtlasUI

var atlasCheckout: AtlasCheckout?

override func viewDidLoad() {
	super.viewDidLoad()

	let opts = Options(clientId: "CLIENT_ID", salesChannel: "SALES_CHANNEL")

	AtlasCheckout.configure(opts) { result in
		if case let .success(checkout) = result {
    	self.atlasCheckout = checkout
    }
  }
}
```

### Configuration using Info.plist

You can provide all configuration options application wide using `Info.plist` with the following keys:
- `ATLASSDK_CLIENT_ID`: String - Client Id (required)
- `ATLASSDK_SALES_CHANNEL`: String - Sales Channel (required)
- `ATLASSDK_USE_SANDBOX`: Bool - Indicates whether sandbox environment should be used
- `ATLASSDK_INTERFACE_LANGUAGE`: String - Checkout interface language

In that case AtlasCheckout configuration is even simpler:

```swift
import AtlasSDK
import AtlasUI

var atlasCheckout: AtlasCheckout?

override func viewDidLoad() {
  super.viewDidLoad()

  AtlasCheckout.configure { result in
    if case let .success(checkout) = result {
      self.atlasCheckout = checkout
    }
  }
}
```

## Usage

Using AtlasCheckout instance configured previously you can interact with SDK, for example:

* Get customer information

 ```swift
 import AtlasSDK
 import AtlasUI

 class ViewController: UIViewController {

    @IBAction private func getCustomerTapped(sender: UIButton) {
      atlasCheckout?.client.customer { result in
        switch result {
          case .failure(let error):
            print("Error: \(error)")

          case .success(let customer):
            print(customer)
        }
      }
    }
 }
 ```

* Start checkout somewhere in your view controller, e.g. when a user tap on a buy button:

 ```swift
 import AtlasSDK
 import AtlasUI

 class ViewController: UIViewController {
	 @IBAction func buyButtonTapped(sender: AnyObject) {
		 atlasCheckout?.presentCheckoutView(sku: "N1242A0WI-K13")
	 } 
 }
 ```

## AtlasSDK Structure

![structure](https://raw.githubusercontent.com/zalando-incubator/atlas-ios/master/Documentation/AtlasSDK%20Structure.png)

### AtlasSDK

AtlasSDK framework is the core framework (think about Cocoa Touch Foundation) that contains:

* all the generic methods
* public models used for API calls
* APIClient that provides all API network calls.

### AtlasUI

AtlasUI uses AtlasSDK as the foundation and provides public checkout functionality to customers.
AtlasUI also contains all the generic UI methods used internally within Atlas SDK. Think about it as Cocoa Touch UIKit.

## AtlasSDK Documentation

[AtlasSDK Reference Documentation](http://cocoadocs.org/docsets/AtlasSDK) is generated automatically during the Pod deployment.

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
