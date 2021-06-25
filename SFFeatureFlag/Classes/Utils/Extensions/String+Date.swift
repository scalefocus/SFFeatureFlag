//
//  String+Date.swift
//  SFFeatureFlag
//
//  Created by Maja Sapunova on 12.6.21.
//

import Foundation

extension String {
    
    func toDate(format: String = "dd-MM-yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: self)
    }
}
