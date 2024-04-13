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
}

extension Router {
    
    var baseURL: String {
        
        return APIKey.baseURL.rawValue
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .signIn, .signUp:
            return .post
        }
    }
    
    var path: String {
        
        switch self {
        case .signIn:
            return Path.signIn.rawValue
        case .signUp:
            return Path.signUp.rawValue
        }
    }
    
    var header: [String : String] {
        
        switch self {
        case .signIn, .signUp:
            return [
                HTTPHeader.Key.contentType.rawValue: HTTPHeader.Value.json.rawValue,
                HTTPHeader.Key.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
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
        }
    }
}
