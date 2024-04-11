//
//  APIError.swift
//  Crewous
//
//  Created by 이중엽 on 4/11/24.
//

import Foundation

enum APIError: Int, Error {
    
    case error200 = 200 // 정상 동작 -> 데이터 모델 이상
    case error400 = 400
    case error401 = 401
    
    case unknown999 = 999
}
