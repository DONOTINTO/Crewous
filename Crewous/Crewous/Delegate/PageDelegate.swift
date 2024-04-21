//
//  PageDelegate.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import Foundation

protocol PageDelegate {
    
    func nextComplete(_ index: Int)
    func previousComplete(_ index: Int)
}
