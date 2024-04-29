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
    case fetchPost(postID: String) // 특정 포스트 조회
    case fetchCrew(fetchCrewQuery: FetchCrewQuery)
    
    case uploadImage(uploadImageQuery: UploadImageQuery)
    case makeCrew(makeCrewQuery: MakeCrewQuery)
    case like2(postID: String, query: Like2Query) // '좋아요2' 적용/취소
    case comment(postID: String, query: CommentQuery) // 댓글 달기
    
    case updateProfile(query: UpdateProfileQuery)
    
    case withDraw
    
    case refresh
}

extension Router {
    
    var baseURL: String {
        
        return APIKey.baseURL.rawValue
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .signIn, .signUp, .uploadImage, .makeCrew, .like2, .comment:
            return .post
        case .refresh, .fetchSelf, .fetchMyCrew, .withDraw, .fetchUser, .fetchPost, .fetchCrew:
            return .get
        case .updateProfile:
            return .put
        }
    }
    
    var path: String {
        
        switch self {
        case .signIn:
            return Path.signIn.rawValue
        case .signUp:
            return Path.signUp.rawValue
        case .fetchSelf, .updateProfile:
            return Path.fetchSelf.rawValue
        case .refresh:
            return Path.refresh.rawValue
        case .fetchMyCrew:
            return Path.fetchMyCrew.rawValue
        case .uploadImage:
            return Path.uploadImage.rawValue
        case .makeCrew:
            return Path.makeCrew.rawValue
        case .like2(let postID, _):
            return "/v1/posts/\(postID)/like-2"
        case .withDraw:
            return Path.withDraw.rawValue
        case .fetchUser(let userID):
            return "/v1/users/\(userID)/profile"
        case .fetchPost(let postID):
            return "/v1/posts/\(postID)"
        case .fetchCrew:
            return Path.makeCrew.rawValue
        case .comment(let postID, _):
            return "/v1/posts/\(postID)/comments"
        }
    }
    
    var header: [String: String] {
        
        switch self {
        case .signIn, .signUp:
            return [
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.json.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .fetchSelf, .fetchMyCrew, .withDraw, .fetchUser, .fetchPost, .fetchCrew:
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
        case .uploadImage, .updateProfile:
            return [
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.data.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .makeCrew, .like2, .comment:
            return [
                HTTPHeader.Key.authorization.rawValue: UDManager.accessToken,
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.json.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .fetchCrew(let fetchCrewQuery):
            return ["limit" : fetchCrewQuery.limit,
                    "product_id" : fetchCrewQuery.product_id]
        case .updateProfile(let updateProfileQuery):
            return ["profile" : updateProfileQuery.profile]
        case .uploadImage(let uploadImageQuery):
            return ["files" : uploadImageQuery.files]
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
        case .like2(_, let like2Query):
            return try? encoder.encode(like2Query)
        case .comment(_, let commentQuery):
            return try? encoder.encode(commentQuery)
        default:
            return nil
        }
    }
}
