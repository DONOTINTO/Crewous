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
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
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
        case title
        case content
        case content1
        case content2
        case content3
        case content4
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
