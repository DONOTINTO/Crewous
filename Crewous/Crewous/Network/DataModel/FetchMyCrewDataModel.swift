//
//  FetchMyCrewDataModel.swift
//  Crewous
//
//  Created by 이중엽 on 4/15/24.
//

import Foundation

struct FetchMyCrewDataModel: Decodable {
    
    let data: [PostData]
}

struct PostData: Decodable {
    let postID: String
    let product_id: String
    let crewName: String
    let introduce: String
    let timeInfo: String
    let placeInfo: String
    let membershipFee: String
    let uniformColor: String
    let content5: String?
    let createdAt: String
    let creator: Creater
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [CrewComment]
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case product_id
        case crewName = "title"
        case introduce = "content"
        case timeInfo = "content1"
        case placeInfo = "content2"
        case membershipFee = "content3"
        case uniformColor = "content4"
        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case hashTags
        case comments
    }
}

struct Creater: Decodable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}

struct CrewComment: Decodable {
    let commentID: String
    let content: String
    let createdAt: String
    let creator: Creater
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createdAt
        case creator
    }
}
