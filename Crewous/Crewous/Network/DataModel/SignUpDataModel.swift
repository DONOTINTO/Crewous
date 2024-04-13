//
//  SignUpDataModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import Foundation

struct SignUpDataModel: Decodable {
    
    let userID: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nick
    }
}
