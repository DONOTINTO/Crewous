//
//  NSObject++.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation

extension NSObject {
    
    var identifier: String {
        
        return String.init(describing: self)
    }
}
