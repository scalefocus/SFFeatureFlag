//
//  Condition.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 8.6.21.
//

import Foundation

public struct Condition: Decodable {
    
    public var key: String
    public var validValues: [String]
    public var inverse: Bool
}
