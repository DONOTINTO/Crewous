//
//  SignInDataModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation

struct SignInDataModel: Decodable {
    
    let userID: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nick, profileImage, accessToken, refreshToken
    }
}
