//
//  MakeCrewQuery.swift
//  Crewous
//
//  Created by 이중엽 on 4/16/24.
//

import Foundation

struct MakeCrewQuery: Encodable {
    let title: String       // crew name
    let content: String     // Introduce
    let content1: String    // time
    let content2: String    // place
    let content3: String    // membershipFee
    let content4: String    // uniform color
    
    let product_id: String
    let files: [String]
}
