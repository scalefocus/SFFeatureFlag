//
//  RemoteConfigServiceProtocol.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 22.6.21.
//

import Foundation

public protocol RemoteConfigServiceProtocol {
    
    /// Typealias for a closure with params returned
    typealias RemoteConfigCompletion = (_ success: Bool, _ error: Error?) -> Void
    
    /// Setup of Remote Config Service
    func setup()
    
    /// Sets config defaults, so that the app behaves as intended before it fetches the config from the remote service
    func setDefaults()
    
    /// Fetches the Remote Config data. This method should be ideally called only once.
    ///
    /// - Parameter completionHandler: A callback triggered when the Remote Config data is fetched.
    func fetchRemoteConfig(_ completionHandler: @escaping RemoteConfigCompletion)
    
    /// Gets the config value for a certain key
    ///
    /// - Parameter key: Config key
    /// - Parameter type: Type of the expected returned value
    func configValue<T>(forKey key: String, type: T.Type) -> T?
}
