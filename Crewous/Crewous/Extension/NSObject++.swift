//
//  NSObject++.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation

extension NSObject {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var id: String {
        return String(describing: self)
    }
}
