//
//  Router.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import Alamofire

enum Router: RouterType {
    
    /// 로그인
    case signIn(signInQuery: SignInQuery)
    /// 회원가입
    case signUp(signUpQuery: SignUpQuery)
    /// 내 프로필 조회
    case fetchSelf
    /// 좋아요2 한 포스트 조회
    case fetchMyCrew
    /// 다른 유저 프로필 조회
    case fetchUser(userID: String)
    /// 특정 포스트 조회
    case fetchPost(postID: String)
    /// 포스트 조회
    case fetchCrew(fetchCrewQuery: FetchCrewQuery)
    
    /// 포스트 이미지 업로드
    case uploadImage(uploadImageQuery: UploadImageQuery)
    /// 포스트 작성
    case makeCrew(makeCrewQuery: MakeCrewQuery)
    /// 포스트 좋아요2
    case like2(postID: String, query: Like2Query) // '좋아요2' 적용/취소
    /// 댓글 작성
    case comment(postID: String, query: CommentQuery) // 댓글 달기
    
    /// 내 프로필 수정
    case updateProfile(query: UpdateProfileQuery)
    
    /// 탈퇴
    case withDraw
    
    /// 엑세스 토큰 갱신
    case refresh
}

extension Router {
    
    var apiType: String {
        
        switch self {
        case .signIn:
            return "로그인"
        case .signUp:
            return "회원가입"
        case .fetchSelf:
            return "내 프로필 조회"
        case .fetchMyCrew:
            return "좋아요2 한 포스트 조회 - 내가 가입한 크루"
        case .fetchUser:
            return "다른 유저 프로필 조회"
        case .fetchPost:
            return "특정 포스트 조회 - 특정 크루 조회"
        case .fetchCrew:
            return "포스트 조회 - 크루 조회"
        case .uploadImage:
            return "이미지 업로드"
        case .makeCrew:
            return "포스트 작성 - 크루 생성"
        case .like2:
            return "포스트 좋아요2 - 크루 가입"
        case .comment:
            return "댓글 작성"
        case .updateProfile:
            return "내 프로필 수정"
        case .withDraw:
            return "탈퇴"
        case .refresh:
            return "엑세스 토큰 갱신"
        }
    }
    
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
