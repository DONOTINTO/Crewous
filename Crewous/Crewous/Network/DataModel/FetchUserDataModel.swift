//
//  FetchSelfDataModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/14/24.
//

import Foundation

struct FetchUserDataModel: Decodable {
    
    let userID: String
    let email: String?
    let nick: String
    let profileImage: String?
    let followers: [Follow]
    let following: [Follow]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nick, followers, following, posts, profileImage
    }
}

struct Follow: Decodable {
    
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
}
