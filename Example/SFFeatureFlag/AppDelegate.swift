//
//  AppDelegate.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 06/08/2021.
//  Copyright (c) 2021 Maja Sapunova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FeatureFlagManager.shared.setup()
        
        return true
    }

}

