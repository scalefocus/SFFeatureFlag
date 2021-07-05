//
//  Condition.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

public struct Condition: Decodable {
    
    /// Key of the condition
    public var key: String
    
    /// Array of valid values for the condition
    public var validValues: [String]
    
    /// Boolean value. If set to true, the opposite values i.e the values that are not contained in the validValues list will fulfill the condition
    public var inverse: Bool
}
