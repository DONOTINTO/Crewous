//
//  WithDrawDataModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/17/24.
//

import Foundation

struct WithDrawDataModel: Decodable {
    
    let userID: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nick
    }
}
