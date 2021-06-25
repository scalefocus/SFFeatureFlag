//
//  Criteria.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

struct VersionRange: Decodable {
    
    var min: String?
    var max: String?
    
}

struct ActiveInterval: Decodable {
    
    var startDate: String?
    var endDate: String?
    
}

struct Criteria: Decodable {
    
    var osVersion: VersionRange?
    var appVersion: VersionRange?
    var activeInterval: ActiveInterval?
    var specificConditions: [Condition]?
    
}
