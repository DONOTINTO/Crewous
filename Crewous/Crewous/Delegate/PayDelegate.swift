//
//  PayDelegate.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import Foundation
import iamport_ios

protocol PayDelegate {
    
    func payComplete(response: IamportResponse)
}
