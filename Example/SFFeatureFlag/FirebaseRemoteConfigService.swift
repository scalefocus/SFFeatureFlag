//
//  FirebaseRemoteConfigService.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 17.6.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseRemoteConfig
import SFFeatureFlag

class FirebaseRemoteConfigService: RemoteConfigServiceProtocol {
   
    //MARK: - Properties
    private var remoteConfig: RemoteConfig?
    
    //MARK: - RemoteConfigServiceProtocol
    func setup() {
        FirebaseApp.configure()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let settings = RemoteConfigSettings()
        
        //WARNING: Use the minimumFetchInterval only for debug builds
        settings.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = settings
        
        setDefaults()
    }
    
    func fetchRemoteConfig(_ completionHandler: @escaping RemoteConfigCompletion) {
        RemoteConfig.remoteConfig().fetch(completionHandler: { [weak self] status, error in
            if status == .success {
                self?.remoteConfig?.activate(completion: { success, error in
                    completionHandler(true, error)
                })
            } else {
                completionHandler(false, error)
            }
        })
    }
    
    func configValue<T>(forKey key: String, type: T.Type) -> T? {
        if type == Data.self {
            return remoteConfig?.configValue(forKey: key).dataValue as? T
        } else if type == String.self {
            return remoteConfig?.configValue(forKey: key).stringValue as? T
        } else if type == Bool.self {
            return remoteConfig?.configValue(forKey: key).boolValue as? T
        } else if type == NSNumber.self {
            return remoteConfig?.configValue(forKey: key).numberValue as? T
        }
        
        return nil
    }
   
    func setDefaults() {
        var defaults = [String: NSObject]()
        
        if let path = Bundle.main.path(forResource: "FeaturesConfigDefaults", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            defaults["features_config"] = data as NSObject
        }
        
        remoteConfig?.setDefaults(defaults)
    }
}
