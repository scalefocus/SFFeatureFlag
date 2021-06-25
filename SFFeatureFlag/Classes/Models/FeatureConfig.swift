//
//  FeatureConfig.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

public struct FeatureConfig: Decodable {
    
    var featureName: String
    var isEnabled: Bool
    var criteria: Criteria?

}
