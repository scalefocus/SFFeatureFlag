//
//  Criteria.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

struct VersionRange: Decodable {
    
    /// The lower boundry of the version range
    var min: String?
    
    /// The upper boundry of the version range
    var max: String?
    
}

struct ActiveInterval: Decodable {
    
    /// The lower boundry of the active interval range
    var startDate: String?
    
    /// The upper boundry of the active interval range
    var endDate: String?
    
}

struct Criteria: Decodable {
    
    /// Optional object. If not nil, it will restrict the availability of the feature only to devices that have iOS version within this range
    var osVersion: VersionRange?
    
    /// Optional object. If not nil, it will restrict the availability of the feature only to specific app versions
    var appVersion: VersionRange?
    
    /// Optional object. If not nil, it will restrict the availability of the feature only for a certain period of time
    var activeInterval: ActiveInterval?
    
    /// Optional array of specific conditions that need to be met in order for the feature to be available
    var specificConditions: [Condition]?
    
}
