//
//  Router.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation
import Alamofire

enum Router: RouterType {
    
    case login(loginQuery: SignInQuery)
}

extension Router {
    
    var baseURL: String {
        
        switch self {
        case .login:
            return APIKey.baseURL.rawValue
        }
    }
    
    var method: HTTPMethod {
        
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        
        switch self {
        case .login:
            return Path.login.rawValue
        }
    }
    
    var header: [String : String] {
        
        switch self {
        case .login:
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
        case .login(let signInQuery):
            return try? encoder.encode(signInQuery)
        }
    }
}
