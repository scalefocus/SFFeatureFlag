//
//  FeatureFlagManager.swift
//  SFFeatureFlag_Example
//
//  Created by Maja Sapunova on 22.6.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import SFFeatureFlag

enum FeatureType: String {
    case profileDetails = "profile_details"
    case recommendedArticles = "recommended_articles"
}

/// Wrapper class around the SFFeatureFlag implementation
class FeatureFlagManager {
    
    static let shared = FeatureFlagManager()
    
    private var featureFlagCenter: FeatureFlagCenter!
    
    /// Does the initial setup for the Feature Flag functionality. This method should be called on app launch
    func setup() {
        let remoteConfigService = FirebaseRemoteConfigService()
        remoteConfigService.setup()
        
        featureFlagCenter = FeatureFlagCenter(remoteConfigService: remoteConfigService)
        featureFlagCenter.fetchFeaturesConfig()
    }
    
    
    /// Determines
    func isFeatureEnabled(featureType: FeatureType, conditionsDataSource: [String: Any] = [:]) -> Bool {
        return featureFlagCenter.isFeatureEnabled(featureKey: featureType.rawValue, specificConditionsDataSource: conditionsDataSource)
    }
}
