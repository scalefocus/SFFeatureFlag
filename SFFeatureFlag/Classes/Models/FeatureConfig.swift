//
//  FeatureConfig.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

public struct FeatureConfig: Decodable {
    
    /// Name of the feature
    var featureName: String
    
    /// Flag indicating whether the feature should be enabled
    var isEnabled: Bool
    
    /// Optional object. If not nil, all the rules defined within this object will be used when evaluating the availabiltiy of the feature.
    /// Note that the criteria will be checked only if the isEnabled flag is set to true
    var criteria: Criteria?

}
