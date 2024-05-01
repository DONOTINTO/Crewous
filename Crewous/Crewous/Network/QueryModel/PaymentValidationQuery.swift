//
//  PaymentValidationQuery.swift
//  Crewous
//
//  Created by 이중엽 on 5/1/24.
//

import Foundation

struct PaymentValidationQuery: Encodable {
    
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}
