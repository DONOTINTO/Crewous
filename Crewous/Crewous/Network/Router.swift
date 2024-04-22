//
//  Router.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import Alamofire

enum Router: RouterType {
    
    case signIn(signInQuery: SignInQuery)
    case signUp(signUpQuery: SignUpQuery)
    case fetchSelf
    case fetchMyCrew    // 좋아요2 한 포스터 정보
    case fetchUser(userID: String)
    case fetchPost(postID: String)
    
    case uploadImage
    case makeCrew(makeCrewQuery: MakeCrewQuery)
    case like2(postID: String) // '좋아요2' 적용/취소
    
    case withDraw
    
    case refresh
}

extension Router {
    
    var baseURL: String {
        
        return APIKey.baseURL.rawValue
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .signIn, .signUp, .uploadImage, .makeCrew, .like2:
            return .post
        case .refresh, .fetchSelf, .fetchMyCrew, .withDraw, .fetchUser, .fetchPost:
            return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .signIn:
            return Path.signIn.rawValue
        case .signUp:
            return Path.signUp.rawValue
        case .fetchSelf:
            return Path.fetchSelf.rawValue
        case .refresh:
            return Path.refresh.rawValue
        case .fetchMyCrew:
            return Path.fetchMyCrew.rawValue
        case .uploadImage:
            return Path.uploadImage.rawValue
        case .makeCrew:
            return Path.makeCrew.rawValue
        case .like2(let postID):
            return "/v1/posts/\(postID)/like-2"
        case .withDraw:
            return Path.withDraw.rawValue
        case .fetchUser(let userID):
            return "/v1/users/\(userID)/profile"
        case .fetchPost(let postID):
            return "/v1/posts/\(postID)"
        }
    }
    
    var header: [String: String] {
        
        switch self {
        case .signIn, .signUp:
            return [
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.json.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .fetchSelf, .fetchMyCrew, .like2, .withDraw, .fetchUser, .fetchPost:
            return [
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken
            ]
        case .refresh:
            return [
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.Key.refresh.rawValue: UDManager.refreshToken
            ]
        case .uploadImage:
            return [
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.data.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .makeCrew:
            return [
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.json.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .like2:
            return ["like_status" : true]
        default:
            return nil
        }
    }
    
    var query: [URLQueryItem]? {
        
        switch self {
        default:
            return nil
        }
    }
    
    var body: Data? {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        switch self {
        case .signIn(let signInQuery):
            return try? encoder.encode(signInQuery)
        case .signUp(let signUpQuery):
            return try? encoder.encode(signUpQuery)
        case .makeCrew(let makeCrewQuery):
            return try? encoder.encode(makeCrewQuery)
        default:
            return nil
        }
    }
}
