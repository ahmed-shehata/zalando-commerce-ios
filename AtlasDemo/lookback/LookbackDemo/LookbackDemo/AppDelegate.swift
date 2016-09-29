//
//  AppDelegate.swift
//  LookbackDemo
//
//  Created by nevyn Bengtsson on 2015-07-17.
//  Copyright (c) 2015 nevyn Bengtsson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // See https://lookback.io/learn/lookback-for-ios/get-started, step "Set up Lookback"
        var warning_replaceTokenWithYourOwnFromLookbackDotIoBeforeRunning : ThenRemoveThisLine
        Lookback.setupWithAppToken("<<INSERT TOKEN HERE>>")
        
        // Should Lookback present its default recording UI whenever the device is shaken? This is a good way to let
        // users report feedback whenever they want.
        Lookback.sharedLookback().shakeToRecord = true
        
        // Should Lookback present its default recording UI immediately when app starts? Not recommended for apps that
        // are sent to AppStore.
#if DEBUG
        Lookback.sharedLookback().feedbackBubbleVisible = true
#endif
        
        return true
    }

}

